//
//  MSSTabBarView.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabBarView.h"
#import "UIView+MSSAutoLayout.h"
#import "MSSTabBarCollectionViewCell+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *  const MSSTabBarViewCellIdentifier = @"tabCell";

// defaults
CGFloat     const MSSTabBarViewDefaultHeight = 44.0f;
CGFloat     const MSSTabBarViewDefaultTabIndicatorHeight = 2.0f;
CGFloat     const MSSTabBarViewDefaultTabPadding = 8.0f;
CGFloat     const MSSTabBarViewDefaultTabUnselectedAlpha = 0.3f;
CGFloat     const MSSTabBarViewDefaultHorizontalContentInset = 8.0f;
NSString *  const MSSTabBarViewDefaultTabTitleFormat = @"Tab %li";
BOOL        const MSSTabBarViewDefaultScrollEnabled = NO;

NSInteger   const MSSTabBarViewMaxDistributedTabs = 5;
CGFloat     const MSSTabBarViewTabTransitionSnapRatio = 0.5f;

CGFloat     const MSSTabBarViewTabOffsetInvalid = -1.0f;

// appearance
NSString *  const MSSTabTextColor = @"tabTextColor";
NSString *  const MSSTabTextFont = @"tabTextFont";
NSString *  const MSSTabIndicatorHeight = @"tabIndicatorHeight";
NSString *  const MSSTabIndicatorInset = @"tabIndicatorInset";
NSString *  const MSSTabTransitionAlphaEffectEnabled = @"alphaEffectEnabled";

@interface MSSTabBarView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tabTitles;
@property (nonatomic, assign) NSInteger tabCount;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *selectionIndicatorView;
@property (nonatomic, weak) MSSTabBarCollectionViewCell *selectedCell;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat previousTabOffset;
@property (nonatomic, assign) NSInteger defaultTabIndex;

@property (nonatomic, assign) BOOL hasRespectedDefaultTabIndex;

@property (nonatomic, assign) BOOL animateDataSourceTransition;

@end

static MSSTabBarCollectionViewCell *_sizingCell;

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

- (instancetype)initWithHeight:(CGFloat)height {
    if (self = [super init]) {
        _height = height;
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    // General
    _tabPadding = MSSTabBarViewDefaultTabPadding;
    CGFloat horizontalInset = MSSTabBarViewDefaultHorizontalContentInset;
    _contentInset = UIEdgeInsetsMake(0.0f, horizontalInset, 0.0f, horizontalInset);
    _tabOffset = MSSTabBarViewTabOffsetInvalid;

    if (_height == 0.0f) {
        _height = MSSTabBarViewDefaultHeight;
    }
    
    // Collection view
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    self.scrollEnabled = MSSTabBarViewDefaultScrollEnabled;
    _tabTextColor = [UIColor blackColor];
    
    // Tab indicator
    _selectionIndicatorView = [UIView new];
    _indicatorAttributes = @{MSSTabIndicatorHeight : @(MSSTabBarViewDefaultTabIndicatorHeight),
                             NSForegroundColorAttributeName : self.tintColor};
}

#pragma mark - Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!self.collectionView.superview) {
        
        // create sizing cell if required
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([MSSTabBarCollectionViewCell class])
                                        bundle:[NSBundle bundleForClass:[MSSTabBarCollectionViewCell class]]];
        [self.collectionView registerNib:cellNib
              forCellWithReuseIdentifier:MSSTabBarViewCellIdentifier];
        if (!_sizingCell) {
            _sizingCell = [[cellNib instantiateWithOwner:self options:nil]objectAtIndex:0];
        }
        
        // collection view
        [self addExpandingSubview:self.collectionView];
        self.collectionView.contentInset = self.contentInset;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    if (!self.selectionIndicatorView.superview) {
        [self updateIndicatorAppearance];
        [self.collectionView addSubview:self.selectionIndicatorView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateTabBarForTabIndex:self.tabOffset];
    
    // if default tab has not yet been displayed
    if (self.tabCount > 0 && !self.selectedCell) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.defaultTabIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:self.animateDataSourceTransition];
    }
}

#pragma mark - Collection View data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self evaluateDataSource];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSSTabBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSSTabBarViewCellIdentifier
                                                                                  forIndexPath:indexPath];
    [self updateCellAppearance:cell];
    
    // default contents
    cell.tabStyle = self.tabStyle;
    cell.title = [self titleAtIndex:indexPath.row];
    
    // populate cell
    if ([self.dataSource respondsToSelector:@selector(tabBarView:populateTab:atIndex:)]) {
        [self.dataSource tabBarView:self populateTab:cell atIndex:indexPath.item];
    }
    
    cell.selectionProgress = MSSTabBarViewDefaultTabUnselectedAlpha;
    
    if ((!self.hasRespectedDefaultTabIndex && indexPath.row == self.defaultTabIndex) ||
        ([self.selectedIndexPath isEqual:indexPath] && self.tabOffset == MSSTabBarViewTabOffsetInvalid)) {
        _hasRespectedDefaultTabIndex = YES;
        [self setTabCellActive:cell indexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Collection View delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewFlowLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeZero;
    
    if (self.sizingStyle == MSSTabSizingStyleDistributed && self.tabCount <= MSSTabBarViewMaxDistributedTabs) { // distributed in frame
        
        CGFloat contentInsetTotal = self.contentInset.left + self.contentInset.right;
        CGFloat totalSpacing = collectionViewLayout.minimumInteritemSpacing * (self.tabCount - 1);
        CGFloat totalWidth = collectionView.bounds.size.width - contentInsetTotal - totalSpacing;
        
        return CGSizeMake(totalWidth / self.tabCount, collectionView.bounds.size.height);
        
    } else { // wrap tab contents
        
        // update sizing cell with population
        if ([self.dataSource respondsToSelector:@selector(tabBarView:populateTab:atIndex:)]) {
            [self.dataSource tabBarView:self populateTab:_sizingCell atIndex:indexPath.item];
        } else  {
            _sizingCell.title = [self titleAtIndex:indexPath.row];
        }
        
        CGSize requiredSize = [_sizingCell systemLayoutSizeFittingSize:CGSizeMake(0.0f, collectionView.bounds.size.height)
                                        withHorizontalFittingPriority:UILayoutPriorityDefaultLow
                                              verticalFittingPriority:UILayoutPriorityRequired];
        requiredSize.width += self.tabPadding;
        cellSize = requiredSize;
    }
    
    return cellSize;
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
    [self reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    
    // add selection indicator height to bottom of collection view inset
    CGFloat indicatorHeight;
    if (self.indicatorAttributes) {
        indicatorHeight = [self.indicatorAttributes[MSSTabIndicatorHeight]floatValue];
    } else {
        indicatorHeight = self.selectionIndicatorHeight;
    }
    contentInset.bottom += indicatorHeight;
    
    self.collectionView.contentInset = contentInset;
}

- (void)setTabIndex:(NSInteger)index animated:(BOOL)animated {
    if (animated) {
        _animatingTabChange = YES;
        [UIView animateWithDuration:0.25f animations:^{
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
    if (self.tabOffset == MSSTabBarViewTabOffsetInvalid) { // only allow default to be set if tab is runtime default
        self.hasRespectedDefaultTabIndex = NO;
        _defaultTabIndex = defaultTabIndex;
    }
}

- (void)setTabIndicatorColor:(UIColor *)tabIndicatorColor {
    _tabIndicatorColor = tabIndicatorColor;
    self.selectionIndicatorView.backgroundColor = tabIndicatorColor;
}

- (void)setSelectionIndicatorHeight:(CGFloat)selectionIndicatorHeight {
    [self updateIndicatorFrameWithHeight:selectionIndicatorHeight];
}

- (void)setSelectionIndicatorInset:(CGFloat)selectionIndicatorInset {
    [self updateIndicatorFrameWithInset:selectionIndicatorInset];
}

- (void)setTabTextColor:(UIColor *)tabTextColor {
    _tabTextColor = tabTextColor;
    [self reloadData];
}

- (void)setTabTextFont:(UIFont *)tabTextFont {
	_tabTextFont = tabTextFont;
	[self reloadData];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    _backgroundView = backgroundView;
    [self addExpandingSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
}

- (void)setDataSource:(id<MSSTabBarViewDataSource>)dataSource {
    self.animateDataSourceTransition = NO;
    [self doSetDataSource:dataSource];
}

- (void)setDataSource:(id<MSSTabBarViewDataSource>)dataSource animated:(BOOL)animated {
    self.animateDataSourceTransition = animated;
    [self doSetDataSource:dataSource];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (BOOL)scrollEnabled {
    return self.collectionView.scrollEnabled;
}

- (void)setUserScrollEnabled:(BOOL)userScrollEnabled {
    self.scrollEnabled = userScrollEnabled;
}

- (BOOL)userScrollEnabled {
    return self.scrollEnabled;
}

- (void)setSizingStyle:(MSSTabSizingStyle)sizingStyle {
    if ((sizingStyle == MSSTabSizingStyleDistributed && self.tabCount <= MSSTabBarViewMaxDistributedTabs) ||
        sizingStyle == MSSTabSizingStyleSizeToFit) {
        _sizingStyle = sizingStyle;
        [self reloadData];
    } else {
        NSLog(@"%@ - Distributed tab spacing is unavailable when using a tab count greater than %li", NSStringFromClass([self class]), (long)MSSTabBarViewMaxDistributedTabs);
    }
}

- (void)setTabStyle:(MSSTabStyle)tabStyle {
    _tabStyle = tabStyle;
    _sizingCell.tabStyle = tabStyle;
    [self reloadData];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.tabIndicatorColor = tintColor;
}

- (void)setTransitionStyle:(MSSTabTransitionStyle)transitionStyle {
    self.selectionIndicatorTransitionStyle = transitionStyle;
    self.tabTransitionStyle = transitionStyle;
}

- (void)setTabAttributes:(NSDictionary<NSString *,id> *)tabAttributes {
    _tabAttributes = tabAttributes;
    [self reloadData];
}

- (void)setSelectionIndicatorTransitionStyle:(MSSTabTransitionStyle)selectionIndicatorTransitionStyle {
    self.indicatorTransitionStyle = selectionIndicatorTransitionStyle;
}

- (void)setIndicatorAttributes:(NSDictionary<NSString *,id> *)indicatorAttributes {
    _indicatorAttributes = indicatorAttributes;
    [self updateIndicatorAppearance];
}

#pragma mark - Tab Bar State

- (void)updateTabBarForTabOffset:(CGFloat)tabOffset {
    
    // calculate the percentage progress of the current tab transition
    float integral;
    CGFloat progress = (CGFloat)modff(tabOffset, &integral);
    BOOL isBackwards = !(tabOffset >= self.previousTabOffset);
    
    if (tabOffset <= 0.0f) { // stick at bottom of tab bar
        
        MSSTabBarCollectionViewCell *firstTabCell = [self collectionViewCellAtTabIndex:0];
        [self updateTabsWithCurrentTabCell:firstTabCell nextTabCell:firstTabCell progress:1.0f backwards:NO];
        [self updateTabSelectionIndicatorWithCurrentTabCell:firstTabCell nextTabCell:firstTabCell progress:1.0f];
        
    } else if (tabOffset >= self.tabCount - 1) { // stick at top of tab bar
        
        MSSTabBarCollectionViewCell *lastTabCell = [self collectionViewCellAtTabIndex:self.tabCount - 1];
        [self updateTabsWithCurrentTabCell:lastTabCell nextTabCell:lastTabCell progress:1.0f backwards:NO];
        [self updateTabSelectionIndicatorWithCurrentTabCell:lastTabCell nextTabCell:lastTabCell progress:1.0f];
        
    } else { // update as required
        if (progress != 0.0f) {
            
            // get the current and next tab cells
            NSInteger currentTabIndex = isBackwards ? ceil(tabOffset) : floor(tabOffset);
            NSInteger nextTabIndex = MAX(0, MIN(self.tabCount - 1, isBackwards ? floor(tabOffset) : ceil(tabOffset)));
            
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
        } else { // finished update - on a tab cell
            
            NSInteger index = floor(tabOffset);
            MSSTabBarCollectionViewCell *selectedCell = [self collectionViewCellAtTabIndex:index];
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:selectedCell];
            
            if (selectedCell && indexPath) {
                [self setTabCellActive:selectedCell indexPath:indexPath];
            }
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
        [self setTabCellActive:cell indexPath:[NSIndexPath indexPathForItem:tabIndex inSection:0]];
    }
}

- (void)setTabCellsInactiveExceptTabIndex:(NSInteger)index {
    for (NSInteger item = 0; item < self.tabCount; item++) {
        if (item != index) {
            MSSTabBarCollectionViewCell *cell = [self collectionViewCellAtTabIndex:item];
            [self setTabCellInactive:cell];
        }
    }
}

- (void)setTabCellActive:(MSSTabBarCollectionViewCell *)cell
               indexPath:(NSIndexPath *)indexPath {
    _selectedCell = cell;
    _selectedIndexPath = indexPath;
    
    cell.selectionProgress = 1.0f;

    if (self.animateDataSourceTransition) {
        [UIView animateWithDuration:0.25f animations:^{
            [self updateSelectionIndicatorViewFrameWithXOrigin:cell.frame.origin.x
                                                      andWidth:cell.frame.size.width
                                             accountForPadding:YES];
        }];
    } else {
        [self updateSelectionIndicatorViewFrameWithXOrigin:cell.frame.origin.x
                                                  andWidth:cell.frame.size.width
                                         accountForPadding:YES];
    }
}

- (void)setTabCellInactive:(MSSTabBarCollectionViewCell *)cell {
    cell.selectionProgress = MSSTabBarViewDefaultTabUnselectedAlpha;
}

- (void)updateTabsWithCurrentTabCell:(MSSTabBarCollectionViewCell *)currentTabCell
                         nextTabCell:(MSSTabBarCollectionViewCell *)nextTabCell
                             progress:(CGFloat)progress
                            backwards:(BOOL)isBackwards {
    
    // Calculate updated alpha values for tabs
    progress = isBackwards ? 1.0f - progress : progress;
    
    if (self.tabTransitionStyle == MSSTabTransitionStyleProgressive) { // progressive
        
        CGFloat unselectedAlpha = MSSTabBarViewDefaultTabUnselectedAlpha;
        CGFloat alphaDiff = (1.0f - unselectedAlpha) * progress;
        CGFloat nextAlpha = unselectedAlpha + alphaDiff;
        CGFloat currentAlpha = 1.0f - alphaDiff;
        
        currentTabCell.selectionProgress = currentAlpha;
        nextTabCell.selectionProgress = nextAlpha;
        
    } else { // snap
        
        CGFloat currentAlpha = (progress > MSSTabBarViewTabTransitionSnapRatio) ? MSSTabBarViewDefaultTabUnselectedAlpha : 1.0f;
        CGFloat targetAlpha = (progress > MSSTabBarViewTabTransitionSnapRatio) ? 1.0f : MSSTabBarViewDefaultTabUnselectedAlpha;
        
        BOOL requiresUpdate = (nextTabCell.selectionProgress != targetAlpha);
        if (requiresUpdate) {
            [UIView animateWithDuration:0.25f animations:^{
                currentTabCell.selectionProgress = currentAlpha;
                nextTabCell.selectionProgress = targetAlpha;
            }];
        }
    }
}

- (void)updateTabSelectionIndicatorWithCurrentTabCell:(MSSTabBarCollectionViewCell *)currentTabCell
                                          nextTabCell:(MSSTabBarCollectionViewCell *)nextTabCell
                                              progress:(CGFloat)progress {
    if (self.tabCount == 0) {
        return;
    }
    
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
    
    CGFloat newX = 0.0f;
    CGFloat newWidth = 0.0f;
    
    if (self.indicatorTransitionStyle == MSSTabTransitionStyleProgressive) {
        
        // calculate width difference
        CGFloat currentTabWidth = currentTabCell.frame.size.width;
        CGFloat nextTabWidth = nextTabCell.frame.size.width;
        CGFloat widthDiff = (nextTabWidth - currentTabWidth) * progress;
        
        // calculate new frame for indicator
        newX = lowerXPos + ((upperXPos - lowerXPos) * progress);
        newWidth = currentTabWidth + widthDiff;
        
        [self updateSelectionIndicatorViewFrameWithXOrigin:newX
                                                  andWidth:newWidth
                                         accountForPadding:YES];
        
    } else if (self.indicatorTransitionStyle == MSSTabTransitionStyleSnap) {
        
        MSSTabBarCollectionViewCell *cell = progress > MSSTabBarViewTabTransitionSnapRatio ? nextTabCell : currentTabCell;
        
        newX = cell.frame.origin.x;
        newWidth = cell.frame.size.width;
        
        BOOL requiresUpdate = self.selectionIndicatorView.frame.origin.x != newX;
        if (requiresUpdate) {
            [UIView animateWithDuration:0.25f animations:^{
                [self updateSelectionIndicatorViewFrameWithXOrigin:newX
                                                          andWidth:newWidth
                                                 accountForPadding:YES];
            }];
        }
    }
}

- (void)updateSelectionIndicatorViewFrameWithXOrigin:(CGFloat)xOrigin
                                            andWidth:(CGFloat)width
                                   accountForPadding:(BOOL)padding {
    if (self.tabCount == 0) {
        return;
    }
    
    if (padding) {
        CGFloat tabInternalPadding = self.tabPadding;
        width -= tabInternalPadding;
        xOrigin += (tabInternalPadding / 2.0f);
    }
    
    self.selectionIndicatorView.frame = CGRectMake(xOrigin,
                                                   self.bounds.size.height - self.selectionIndicatorInset - self.selectionIndicatorHeight,
                                                   width,
                                                   self.selectionIndicatorHeight);
    [self updateCollectionViewScrollOffset];
}

- (void)updateCollectionViewScrollOffset {
    if (self.sizingStyle != MSSTabSizingStyleDistributed) {
        
        // scroll collection view to center selection indicator if possible
        CGFloat collectionViewWidth = self.collectionView.bounds.size.width - self.contentInset.left - self.contentInset.right;
        CGFloat scrollViewX = MAX(0, self.selectionIndicatorView.center.x - (collectionViewWidth / 2.0f));
        [self.collectionView scrollRectToVisible:CGRectMake(scrollViewX,
                                                            self.collectionView.frame.origin.y,
                                                            collectionViewWidth,
                                                            self.collectionView.frame.size.height)
                                        animated:NO];
    }
}

- (MSSTabBarCollectionViewCell *)collectionViewCellAtTabIndex:(NSInteger)tabIndex {
    if (tabIndex >= 0 && tabIndex < self.tabCount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tabIndex inSection:0];
        return (MSSTabBarCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - Internal

- (NSArray *)evaluateTabTitles {
    NSArray *tabTitles = [[self.dataSource tabTitlesForTabBarView:self]copy];
    return tabTitles;
}

- (NSInteger)evaluateDataSource {
    NSInteger tabCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsForTabBarView:)]) {
        tabCount = [self.dataSource numberOfItemsForTabBarView:self];
        
    } else if ([self.dataSource respondsToSelector:@selector(tabTitlesForTabBarView:)]) {
        
        self.tabTitles = [self evaluateTabTitles];
        tabCount = self.tabTitles.count;
    }
    _tabCount = tabCount;
    return tabCount;
}

- (NSString *)titleAtIndex:(NSInteger)index {
    if (self.tabTitles) {
        return self.tabTitles[index];
    } else {
        return [NSString stringWithFormat:MSSTabBarViewDefaultTabTitleFormat, (long)(index + 1)];
    }
}

- (void)reset {
    _selectedCell = nil;
    _selectedIndexPath = nil;
    _hasRespectedDefaultTabIndex = NO;
    _tabOffset = MSSTabBarViewTabOffsetInvalid;
    _previousTabOffset = MSSTabBarViewTabOffsetInvalid;
}

- (void)doSetDataSource:(id<MSSTabBarViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reset];
    if ([dataSource respondsToSelector:@selector(defaultTabIndexForTabBarView:)]) {
        self.defaultTabIndex = [dataSource defaultTabIndexForTabBarView:self];
    }
    [self.collectionView reloadData];
    [self setNeedsLayout];
}

- (void)reloadData {
    if (self.tabOffset == MSSTabBarViewTabOffsetInvalid) {
        _hasRespectedDefaultTabIndex = NO;
    }
    [self.collectionView reloadData];
}

- (void)updateCellAppearance:(MSSTabBarCollectionViewCell *)cell {
    
    // default appearance
    if (self.tabAttributes) {
        UIColor *tabTextColor;
        if ((tabTextColor = self.tabAttributes[MSSTabTextColor]) ||
            (tabTextColor = self.tabAttributes[NSForegroundColorAttributeName])) {
            
            cell.textColor = tabTextColor;
        }
        
        UIFont *tabTextFont;
        if ((tabTextFont = self.tabAttributes[MSSTabTextFont]) ||
            (tabTextFont = self.tabAttributes[NSFontAttributeName])) {
            cell.textFont = tabTextFont;
        }
        
        UIColor *tabBackgroundColor;
        if ((tabBackgroundColor = self.tabAttributes[NSBackgroundColorAttributeName])) {
            cell.tabBackgroundColor = tabBackgroundColor;
        }
        
        NSNumber *alphaEffectEnabled;
        if ((alphaEffectEnabled = self.tabAttributes[MSSTabTransitionAlphaEffectEnabled])) {
            cell.alphaEffectEnabled = [alphaEffectEnabled boolValue];
        }
        
    } else {
        cell.textColor = self.tabTextColor;
        if(self.tabTextFont){
            cell.textFont = self.tabTextFont;
        }
    }
    
    // selected appearance
    if (self.selectedTabAttributes) {
        UIColor *selectedTabTextColor;
        if ((selectedTabTextColor = self.selectedTabAttributes[MSSTabTextColor]) ||
            (selectedTabTextColor = self.selectedTabAttributes[NSForegroundColorAttributeName])) {
            
            cell.selectedTextColor = selectedTabTextColor;
        }
        
        UIFont *selectedTabTextFont;
        if ((selectedTabTextFont = self.selectedTabAttributes[MSSTabTextFont]) ||
            (selectedTabTextFont = self.selectedTabAttributes[NSFontAttributeName])) {
            
            cell.selectedTextFont = selectedTabTextFont;
        }
        
        UIColor *selectedTabBackgroundColor;
        if ((selectedTabBackgroundColor = self.selectedTabAttributes[NSBackgroundColorAttributeName])) {
            cell.selectedTabBackgroundColor = selectedTabBackgroundColor;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setContentBottomMargin:(self.selectionIndicatorInset + self.selectionIndicatorHeight)];
}

- (void)updateIndicatorAppearance {
    if (self.indicatorAttributes) {
        
        UIColor *indicatorColor;
        if ((indicatorColor = self.indicatorAttributes[NSForegroundColorAttributeName])) {
            self.selectionIndicatorView.backgroundColor = indicatorColor;
        }
        
        NSNumber *indicatorHeight;
        if ((indicatorHeight = self.indicatorAttributes[MSSTabIndicatorHeight])) {
            [self updateIndicatorFrameWithHeight:[indicatorHeight floatValue]];
        }
        
        NSNumber *indicatorInset;
        if ((indicatorInset = self.indicatorAttributes[MSSTabIndicatorInset])) {
            [self updateIndicatorFrameWithInset:[indicatorInset floatValue]];
        }
    }
}

- (void)updateIndicatorFrameWithHeight:(CGFloat)height {
    CGRect frame = self.selectionIndicatorView.frame;
    if (frame.size.height != height) {
        _selectionIndicatorHeight = height;
        CGFloat diff = height - frame.size.height;
        frame.origin = CGPointMake(frame.origin.x, frame.origin.y - diff);
        frame.size = CGSizeMake(frame.size.width, height);
        self.selectionIndicatorView.frame = frame;
    }
}

- (void)updateIndicatorFrameWithInset:(CGFloat)inset {
    _selectionIndicatorInset = inset;
    CGRect frame = self.selectionIndicatorView.frame;
    frame.origin = CGPointMake(frame.origin.x, self.bounds.size.height - inset - self.selectionIndicatorHeight);
    self.selectionIndicatorView.frame = frame;
}

#pragma clang diagnostic pop

@end
