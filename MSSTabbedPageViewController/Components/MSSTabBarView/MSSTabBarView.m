//
//  MSSTabBarView.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabBarView.h"
#import "UIView+MSSAutoLayout.h"
#import "MSSTabBarCollectionViewCell.h"

NSString *  const MSSTabBarViewCellIdentifier = @"tabCell";

// defaults
CGFloat     const MSSTabBarViewDefaultHeight = 44.0f;
CGFloat     const MSSTabBarViewDefaultTabIndicatorHeight = 2.0f;
CGFloat     const MSSTabBarViewDefaultTabPadding = 8.0f;
CGFloat     const MSSTabBarViewDefaultTabUnselectedAlpha = 0.3f;
CGFloat     const MSSTabBarViewDefaultHorizontalContentInset = 8.0f;
NSString *  const MSSTabBarViewDefaultTabTitleFormat = @"Tab %lu";

@interface MSSTabBarView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tabTitles;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *selectionIndicatorView;

@property (nonatomic, assign) CGFloat previousTabOffset;

@property (nonatomic, assign) CGFloat selectionIndicatorHeight;

@property (nonatomic, assign) BOOL hasRespectedDefaultTabIndex;

@end

static MSSTabBarCollectionViewCell *sizingCell;

@implementation MSSTabBarView

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    // General
    _tabPadding = MSSTabBarViewDefaultTabPadding;
    CGFloat horizontalInset = MSSTabBarViewDefaultHorizontalContentInset;
    _contentInset = UIEdgeInsetsMake(0.0f, horizontalInset, 0.0f, horizontalInset);
    
    // Collection view
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    // Tab indicator
    _selectionIndicatorHeight = MSSTabBarViewDefaultTabIndicatorHeight;
    _selectionIndicatorView = [UIView new];
    _tabIndicatorColor = self.tintColor;
    _tabTextColor = [UIColor blackColor];
}

#pragma mark - Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!self.collectionView.superview) {
        
        // create sizing cell if required
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([MSSTabBarCollectionViewCell class])
                                        bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:cellNib
              forCellWithReuseIdentifier:MSSTabBarViewCellIdentifier];
        if (!sizingCell) {
            sizingCell = [[cellNib instantiateWithOwner:self options:nil]objectAtIndex:0];
        }
        
        // collection view
        [self addExpandingSubview:self.collectionView];
        self.collectionView.contentInset = self.contentInset;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    if (!self.selectionIndicatorView.superview) {
        self.selectionIndicatorView.backgroundColor = self.tabIndicatorColor;
        [self.collectionView addSubview:self.selectionIndicatorView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateTabBarForTabIndex:self.tabOffset];
}

#pragma mark - Collection View data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    self.tabTitles = [self evaluateTabTitles];
    return self.tabTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.tabTitles[indexPath.row];
    MSSTabBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSSTabBarViewCellIdentifier
                                                                                  forIndexPath:indexPath];
    
    cell.titleLabel.text = title;
    cell.backgroundColor = [UIColor clearColor];
    
    // check whether this is the default run
    // cell should be set active if it is the default
    if (!self.hasRespectedDefaultTabIndex && indexPath.row == self.defaultTabIndex) {
        
        self.hasRespectedDefaultTabIndex = YES;
        [self setTabCellActive:cell];
        
    } else { // standard cell inactive
        
        cell.titleLabel.alpha = MSSTabBarViewDefaultTabUnselectedAlpha;
    }

    return cell;
}

#pragma mark - Collection View delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    sizingCell.titleLabel.text = self.tabTitles[indexPath.row];
    CGSize requiredSize = [sizingCell systemLayoutSizeFittingSize:CGSizeMake(0.0f, collectionView.bounds.size.height)
                                    withHorizontalFittingPriority:UILayoutPriorityDefaultLow
                                          verticalFittingPriority:UILayoutPriorityRequired];
    requiredSize.width += self.tabPadding;
    
    return requiredSize;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:tabSelectedAtIndex:)]) {
        [self.delegate tabBarView:self tabSelectedAtIndex:indexPath.row];
    }
}

#pragma mark - Public

- (void)setTabPadding:(CGFloat)tabPadding {
    _tabPadding = tabPadding;
    [self.collectionView reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    
    // add selection indicator height to bottom of collection view inset
    contentInset.bottom += self.selectionIndicatorHeight;
    
    self.collectionView.contentInset = contentInset;
}

- (void)setTabIndex:(NSInteger)index animated:(BOOL)animated {
    if (animated) {
        _animatingTabChange = YES;
        [UIView animateWithDuration:0.3f animations:^{
            [self updateTabBarForTabIndex:index];
        } completion:^(BOOL finished) {
            _animatingTabChange = NO;
        }];
    } else {
        [self updateTabBarForTabIndex:index];
    }
}

- (void)setTabOffset:(CGFloat)offset {
    _previousTabOffset = _tabOffset;
    _tabOffset = offset;
    [self updateTabBarForTabOffset:offset];
}

- (void)setDefaultTabIndex:(NSInteger)defaultTabIndex {
    if (self.tabOffset == 0.0f) { // only allow default to be set if tab is runtime default
        self.hasRespectedDefaultTabIndex = NO;
        _defaultTabIndex = defaultTabIndex;
    }
}

- (void)setTabIndicatorColor:(UIColor *)tabIndicatorColor {
    _tabIndicatorColor = tabIndicatorColor;
    self.selectionIndicatorView.backgroundColor = tabIndicatorColor;
}

- (void)setTabTextColor:(UIColor *)tabTextColor {
    _tabTextColor = tabTextColor;
    [self.collectionView reloadData];
}

#pragma mark - Tab Bar State

- (void)updateTabBarForTabOffset:(CGFloat)tabOffset {
    
    // calculate the percentage progress of the current tab transition
    float integral;
    CGFloat progress = (CGFloat)modff(tabOffset, &integral);
    BOOL isBackwards = !(tabOffset >= self.previousTabOffset);
    
    if (progress != 0.0f) {
        
        // get the current and next tab cells
        NSInteger currentTabIndex = isBackwards ? ceil(tabOffset) : floor(tabOffset);
        NSInteger nextTabIndex = MAX(0, MIN(self.tabTitles.count - 1, isBackwards ? floor(tabOffset) : ceil(tabOffset)));

        MSSTabBarCollectionViewCell *currentTabCell = [self collectionViewCellAtTabIndex:currentTabIndex];
        MSSTabBarCollectionViewCell *nextTabCell = [self collectionViewCellAtTabIndex:nextTabIndex];
        
        // update tab bar components
        if (currentTabCell != nextTabCell && (currentTabCell && nextTabCell)) {
            [self updateTabsWithCurrentTabCell:currentTabCell
                                   nextTabCell:nextTabCell
                                      progress:progress
                                     backwards:isBackwards];
            [self updateTabSelectionIndicatorWithCurrentTabCell:currentTabCell
                                                    nextTabCell:nextTabCell
                                                       progress:progress];
        }
    }
}

- (void)updateTabBarForTabIndex:(NSInteger)tabIndex {
    MSSTabBarCollectionViewCell *cell = [self collectionViewCellAtTabIndex:tabIndex];
    if (cell) {
        
        // update tab offsets
        _previousTabOffset = _tabOffset;
        _tabOffset = tabIndex;
        
        // update tab bar cells
        [self setTabCellsInactiveExceptTabIndex:tabIndex];
        [self setTabCellActive:cell];
    }
}

- (void)setTabCellsInactiveExceptTabIndex:(NSInteger)index {
    for (NSInteger item = 0; item < self.tabTitles.count; item++) {
        if (item != index) {
            MSSTabBarCollectionViewCell *cell = [self collectionViewCellAtTabIndex:item];
            [self setTabCellInactive:cell];
        }
    }
}

- (void)setTabCellActive:(MSSTabBarCollectionViewCell *)cell {
    cell.titleLabel.alpha = 1.0f;
    [self updateSelectionIndicatorViewFrameWithXOrigin:cell.frame.origin.x
                                              andWidth:cell.frame.size.width
                                     accountForPadding:YES];
}

- (void)setTabCellInactive:(MSSTabBarCollectionViewCell *)cell {
    cell.titleLabel.alpha = MSSTabBarViewDefaultTabUnselectedAlpha;
}

- (void)updateTabsWithCurrentTabCell:(MSSTabBarCollectionViewCell *)currentTabCell
                         nextTabCell:(MSSTabBarCollectionViewCell *)nextTabCell
                             progress:(CGFloat)progress
                            backwards:(BOOL)isBackwards {
    
    // Calculate updated alpha values for tabs
    progress = isBackwards ? 1.0f - progress : progress;
    CGFloat unselectedAlpha = MSSTabBarViewDefaultTabUnselectedAlpha;
    CGFloat alphaDiff = (1.0f - unselectedAlpha) * progress;
    CGFloat nextAlpha = unselectedAlpha + alphaDiff;
    CGFloat currentAlpha = 1.0f - alphaDiff;
    
    currentTabCell.titleLabel.alpha = currentAlpha;
    nextTabCell.titleLabel.alpha = nextAlpha;
}

- (void)updateTabSelectionIndicatorWithCurrentTabCell:(MSSTabBarCollectionViewCell *)currentTabCell
                                          nextTabCell:(MSSTabBarCollectionViewCell *)nextTabCell
                                              progress:(CGFloat)progress {
    
    // calculate the upper and lower x origins for cells
    CGFloat upperXPos = MAX(nextTabCell.frame.origin.x, currentTabCell.frame.origin.x);
    CGFloat lowerXPos = MIN(nextTabCell.frame.origin.x, currentTabCell.frame.origin.x);
    
    // swap cells according to which has lowest X origin
    BOOL backwards = (nextTabCell.frame.origin.x == lowerXPos);
    if (backwards) {
        MSSTabBarCollectionViewCell *temp = nextTabCell;
        nextTabCell = currentTabCell;
        currentTabCell = temp;
    }
    
    // calculate width difference
    CGFloat currentTabWidth = currentTabCell.frame.size.width;
    CGFloat nextTabWidth = nextTabCell.frame.size.width;
    CGFloat widthDiff = (nextTabWidth - currentTabWidth) * progress;
    
    // calculate new frame for indicator
    CGFloat newX = lowerXPos + ((upperXPos - lowerXPos) * progress);
    CGFloat newWidth = currentTabWidth + widthDiff;
    [self updateSelectionIndicatorViewFrameWithXOrigin:newX
                                              andWidth:newWidth
                                     accountForPadding:YES];
}

- (void)updateSelectionIndicatorViewFrameWithXOrigin:(CGFloat)xOrigin
                                            andWidth:(CGFloat)width
                                   accountForPadding:(BOOL)padding {
    
    if (padding) {
        CGFloat tabInternalPadding = self.tabPadding;
        width -= tabInternalPadding;
        xOrigin += (tabInternalPadding / 2.0f);
    }
    
    self.selectionIndicatorView.frame = CGRectMake(xOrigin,
                                                   self.bounds.size.height - self.selectionIndicatorHeight,
                                                   width,
                                                   self.selectionIndicatorHeight);
    [self updateCollectionViewScrollOffset];
}

- (void)updateCollectionViewScrollOffset {
    
    // scroll collection view to center selection indicator if possible
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width - self.contentInset.left - self.contentInset.right;
    CGFloat scrollViewX = MAX(0, self.selectionIndicatorView.center.x - (collectionViewWidth / 2.0f));
    [self.collectionView scrollRectToVisible:CGRectMake(scrollViewX,
                                                        self.collectionView.frame.origin.y,
                                                        collectionViewWidth,
                                                        self.collectionView.frame.size.height)
                                    animated:NO];
}

- (MSSTabBarCollectionViewCell *)collectionViewCellAtTabIndex:(NSInteger)tabIndex {
    if (tabIndex >= 0 && tabIndex < self.tabTitles.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tabIndex inSection:0];
        return (MSSTabBarCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - Internal

- (NSArray *)evaluateTabTitles {
    NSMutableArray *tabTitles = [[self.dataSource tabTitlesForTabBarView:self]mutableCopy];
    
    if (self.expectedTabCount != 0) {
        for (NSInteger tab = tabTitles.count; tab < self.expectedTabCount; tab++) {
            NSString *title = [NSString stringWithFormat:MSSTabBarViewDefaultTabTitleFormat, (unsigned long)tab + 1];
            [tabTitles addObject:title];
        }
    }
    return tabTitles;
}

@end
