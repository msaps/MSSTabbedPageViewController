//
//  MSSTabbedPageViewController.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"
#import "MSSPageViewController+Private.h"
#import "MSSTabBarView+Private.h"

@implementation MSSTabbedPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.provideOutOfBoundsUpdates = NO;
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

- (NSInteger)defaultTabIndexForTabBarView:(MSSTabBarView *)tabBarView {
    if (self.currentPage == MSSPageViewControllerPageNumberInvalid) { // return default page if page has not been moved
        return self.defaultPageIndex;
    }
    return self.currentPage;
}

#pragma mark - Tab bar delegate

- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    if (index != self.currentPage && !self.isAnimatingPageUpdate && index < self.viewControllers.count) {
        self.allowScrollViewUpdates = NO;
        self.userInteractionEnabled = NO;
        
        [self.tabBarView setTabIndex:index animated:YES];
        typeof(self) __weak weakSelf = self;
        [self moveToPageAtIndex:index
                     completion:^(UIViewController *newViewController, BOOL animated, BOOL transitionFinished) {
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
    
    if (!self.isDragging) {
        self.tabBarView.userInteractionEnabled = YES;
    }
    self.allowScrollViewUpdates = YES;
    self.userInteractionEnabled = YES;
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
