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
        CGFloat tabHeight = 0.0f;
        if ([self.delegate respondsToSelector:@selector(tabbedPageViewControllerHeightForTabBar:)]) {
            tabHeight = [self.delegate tabbedPageViewControllerHeightForTabBar:self];
        }
        _tabBarView = [[MSSTabBarView alloc]initWithHeight:tabHeight];
        self.tabBarView.dataSource = self;
        self.tabBarView.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addExpandingSubview:self.contentView];
    [self setUpContentView];
    
    [self.pageViewController addToParentViewController:self withView:self.contentView];
    [self.contentView addPinnedToTopAndSidesSubview:self.tabBarView
                                  withHeight:self.tabBarView.height];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self setUpContentView];
    } completion:nil];
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

- (void)pageViewController:(MSSPageViewController *)pageViewController
           didScrollToPage:(NSInteger)page {
    if (!pageViewController.isDragging) {
        [self.tabBarView setTabIndex:page animated:YES];
    }
}

- (void)pageViewController:(MSSPageViewController *)pageViewController
 didPrepareViewControllers:(NSArray *)viewControllers {
    
    self.tabBarView.expectedTabCount = self.pageViewController.numberOfPages;
    self.tabBarView.defaultTabIndex = self.pageViewController.defaultPageIndex;
    
    for (UIViewController<MSSTabbedPageChildViewController> *viewController in viewControllers) {
        if ([viewController conformsToProtocol:@protocol(MSSTabbedPageChildViewController)]) {
            viewController.tabBarView = self.tabBarView;
            viewController.requiredContentInset = UIEdgeInsetsMake(self.tabBarView.height,
                                                                   0.0f,
                                                                   0.0f,
                                                                   0.0f);
        }
    }
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

- (id<MSSTabbedPageViewControllerDelegate>)delegate {
    if (_delegate) {
        return _delegate;
    }
    return self;
}

#pragma mark - Internal

- (void)setUpContentView {
    UIEdgeInsets margins = self.contentView.layoutMargins;
    margins.top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    margins.left = 0.0f;
    margins.right = 0.0f;
    self.contentView.layoutMargins = margins;
}

@end
