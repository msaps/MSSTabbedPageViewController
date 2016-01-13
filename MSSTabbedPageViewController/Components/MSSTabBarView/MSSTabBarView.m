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

CGFloat const MSSTabBarViewDefaultHeight = 44.0f;
NSString *const MSSTabBarViewCellIdentifier = @"tabCell";

CGFloat const MSSTabBarViewDefaultTabPadding = 8.0f;
CGFloat const MSSTabBarViewDefaultHorizontalContentInset = 8.0f;

@interface MSSTabBarView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tabTitles;

@property (nonatomic, strong) UICollectionView *collectionView;

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
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _tabPadding = MSSTabBarViewDefaultTabPadding;
    CGFloat horizontalInset = MSSTabBarViewDefaultHorizontalContentInset;
    _contentInset = UIEdgeInsetsMake(0.0f, horizontalInset, 0.0f, horizontalInset);
}

#pragma mark - Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!self.collectionView.superview) {
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([MSSTabBarCollectionViewCell class])
                                        bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:cellNib
              forCellWithReuseIdentifier:MSSTabBarViewCellIdentifier];
        
        if (!sizingCell) { // create sizing cell if required
            sizingCell = [[cellNib instantiateWithOwner:self options:nil]objectAtIndex:0];
        }
        
        [self addExpandingSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.contentInset = self.contentInset;
    }
}

#pragma mark - Collection View data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    self.tabTitles = [self.dataSource tabTitlesForTabBarView:self];
    return self.tabTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSSTabBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSSTabBarViewCellIdentifier
                                                                                  forIndexPath:indexPath];
    NSString *title = self.tabTitles[indexPath.row];
    
    cell.titleLabel.text = title;
    
    cell.backgroundColor = [UIColor redColor];
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
    self.collectionView.contentInset = contentInset;
}

@end
