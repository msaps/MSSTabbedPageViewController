//
//  MSSTabbedPageViewController.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"

@implementation MSSTabbedPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController.navigationBar isMemberOfClass:[MSSTabNavigationBar class]]) {
        MSSTabNavigationBar *navigationBar = (MSSTabNavigationBar *)self.navigationController.navigationBar;
        navigationBar.tabBarDataSource = self;
        navigationBar.tabBarDelegate = self;
        _tabBarView = navigationBar.tabBarView;
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

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return nil;
}

#pragma mark - Tab bar delegate

- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    self.allowScrollViewUpdates = NO;
    
    [self.tabBarView setTabIndex:index animated:YES];
    typeof(self) __weak weakSelf = self;
    [self moveToPageAtIndex:index
                 completion:^(UIViewController *newController,
                              BOOL animationFinished,
                              BOOL transitionFinished) {
                     typeof(weakSelf) __strong strongSelf = weakSelf;
                     strongSelf.allowScrollViewUpdates = YES;
                 }];
}

#pragma mark - Page View Controller delegate

- (void)pageViewController:(MSSPageViewController *)pageViewController
     didScrollToPageOffset:(CGFloat)pageOffset
                 direction:(MSSPageViewControllerScrollDirection)scrollDirection {
    [self.tabBarView setTabOffset:pageOffset];
}

@end
