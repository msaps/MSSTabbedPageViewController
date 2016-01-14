//
//  MSSTabbedPageViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"

@interface MSSTabbedPageViewController () <MSSPageViewControllerDelegate, MSSTabBarViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@end

@implementation MSSTabbedPageViewController

@synthesize dataSource = _dataSource;

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    if (!_contentView) {
        _contentView = [UIView new];
    }
    
    if (!_pageViewController) {
        _pageViewController = [MSSPageViewController new];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
    if (!_tabBarView) {
        _tabBarView = [MSSTabBarView new];
        self.tabBarView.dataSource = self;
        self.tabBarView.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpContentView];
    
    [self.pageViewController addToParentViewController:self withView:self.contentView];
    [self.contentView addPinnedToTopAndSidesSubview:self.tabBarView
                                  withHeight:MSSTabBarViewDefaultHeight];
    
    self.tabBarView.expectedTabCount = self.pageViewController.numberOfPages;
    self.tabBarView.defaultTabIndex = self.pageViewController.defaultPageIndex;
}

#pragma mark - Page View Controller data source

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    return nil;
}

- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Page View Controller delegate

- (void)pageViewController:(MSSPageViewController *)pageViewController
     didScrollToPageOffset:(CGFloat)pageOffset
                 direction:(MSSPageViewControllerScrollDirection)scrollDirection {
    [self.tabBarView setTabOffset:pageOffset];
}

#pragma mark - Tab Bar View data source

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return nil;
}

#pragma mark - Tab Bar View delegate

- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    self.pageViewController.allowScrollViewUpdates = NO;
    
    [self.tabBarView setTabIndex:index animated:YES];
    typeof(self) __weak weakSelf = self;
    [self.pageViewController moveToPageAtIndex:index
                                    completion:^(UIViewController *newController,
                                                 BOOL animationFinished,
                                                 BOOL transitionFinished) {
                                        typeof(weakSelf) __strong strongSelf = weakSelf;
                                        strongSelf.pageViewController.allowScrollViewUpdates = YES;
                                        
    }];
}

#pragma mark - Public

- (void)setDataSource:(id<MSSTabbedPageViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    self.pageViewController.dataSource = dataSource;
    self.tabBarView.dataSource = dataSource;
}

- (id<MSSTabbedPageViewControllerDataSource>)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    return self;
}

#pragma mark - Internal

- (void)setUpContentView {
    [self.view addExpandingSubview:self.contentView];
    
    UIEdgeInsets margins = self.contentView.layoutMargins;
    margins.top = self.requiredTopMargin;
    margins.left = 0.0f;
    margins.right = 0.0f;
    self.contentView.layoutMargins = margins;
}

@end
