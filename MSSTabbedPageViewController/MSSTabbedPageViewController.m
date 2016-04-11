//
//  MSSTabbedPageViewController.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"
#import "MSSPageViewControllerPrivate.h"
#import "MSSTabNavigationBarPrivate.h"

@interface MSSTabbedPageViewController () <UINavigationControllerDelegate>

@property (nonatomic, weak) MSSTabNavigationBar *tabNavigationBar;

@property (nonatomic, assign) BOOL allowTabBarRequiredCancellation;

@end

@implementation MSSTabbedPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.provideOutOfBoundsUpdates = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set up navigation bar for tabbed page view if available
    if ([self.navigationController.navigationBar isMemberOfClass:[MSSTabNavigationBar class]] && !self.tabBarView) {
        MSSTabNavigationBar *navigationBar = (MSSTabNavigationBar *)self.navigationController.navigationBar;
        self.navigationController.delegate = self;
        _tabNavigationBar = navigationBar;
        
        MSSTabBarView *tabBarView = navigationBar.tabBarView;
        tabBarView.dataSource = self;
        tabBarView.delegate = self;
        _tabBarView = tabBarView;
        tabBarView.defaultTabIndex = (self.currentPage != self.defaultPageIndex) ? self.currentPage : self.defaultPageIndex;
        
        BOOL isInitialController = (self.navigationController.viewControllers.firstObject == self);
        [navigationBar tabbedPageViewController:self viewWillAppear:animated isInitial:isInitialController];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.tabNavigationBar && (self.tabBarView == self.tabNavigationBar.tabBarView)) {
        
        // if next view controller is not tabbed page view controller update navigation bar
        self.allowTabBarRequiredCancellation = ![self.navigationController.visibleViewController isKindOfClass:[MSSTabbedPageViewController class]];
        if (self.allowTabBarRequiredCancellation) {
            [self.tabNavigationBar tabbedPageViewController:self viewWillDisappear:animated];
        }
        
        // remove the current tab bar
        _tabBarView = nil;
    }
}

#pragma mark - Public

- (void)setDelegate:(id<MSSPageViewControllerDelegate>)delegate {
    // only allow self to be page view controller delegate
    if (delegate == (id<MSSPageViewControllerDelegate>)self) {
        [super setDelegate:delegate];
    }
}

#pragma mark - Tab bar data source

- (NSInteger)numberOfItemsForTabBarView:(MSSTabBarView *)tabBarView {
    return self.viewControllers.count;
}

- (void)tabBarView:(MSSTabBarView *)tabBarView
       populateTab:(MSSTabBarCollectionViewCell *)tab
           atIndex:(NSInteger)index {
    
}

#pragma mark - Tab bar delegate

- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    if (index != self.currentPage && !self.isAnimatingPageUpdate && index < self.viewControllers.count) {
        self.allowScrollViewUpdates = NO;
        self.userInteractionEnabled = NO;
        
        [self.tabBarView setTabIndex:index animated:YES];
        typeof(self) __weak weakSelf = self;
        [self moveToPageAtIndex:index
                     completion:^(UIViewController *newController,
                                  BOOL animationFinished,
                                  BOOL transitionFinished) {
                         typeof(weakSelf) __strong strongSelf = weakSelf;
                         strongSelf.allowScrollViewUpdates = YES;
                         strongSelf.userInteractionEnabled = YES;
                     }];
    }
}

#pragma mark - Page View Controller delegate

- (void)pageViewController:(MSSPageViewController *)pageViewController
     didScrollToPageOffset:(CGFloat)pageOffset
                 direction:(MSSPageViewControllerScrollDirection)scrollDirection {
    [self.tabBarView setTabOffset:pageOffset];
}

- (void)pageViewController:(MSSPageViewController *)pageViewController
          willScrollToPage:(NSInteger)newPage
               currentPage:(NSInteger)currentPage {
    self.tabBarView.userInteractionEnabled = NO;
}

- (void)pageViewController:(MSSPageViewController *)pageViewController
           didScrollToPage:(NSInteger)page {
    [self.tabBarView setTabOffset:page];
    
    if (!self.isDragging) {
        self.tabBarView.userInteractionEnabled = YES;
    }
    self.allowScrollViewUpdates = YES;
    self.userInteractionEnabled = YES;
}

#pragma mark - Navigation Controller delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    // Fix for navigation controller swipe back gesture
    // Manually set tab bar to hidden if gesture was cancelled
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = navigationController.topViewController.transitionCoordinator;
    [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled] && self.allowTabBarRequiredCancellation) {
            self.tabNavigationBar.tabBarRequired = NO;
            [self.tabNavigationBar setNeedsLayout];
        }
    }];
}

#pragma mark - Scroll View delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    self.tabBarView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.tabBarView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.tabBarView.userInteractionEnabled = YES;
}

@end
