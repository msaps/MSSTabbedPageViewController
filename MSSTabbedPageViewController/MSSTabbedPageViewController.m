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
#import "UIView+MSSAnimations.h"

@interface MSSTabbedPageViewController ()

@property (nonatomic, weak) MSSTabNavigationBar *tabNavigationBar;

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
    if ([self.navigationController.navigationBar isMemberOfClass:[MSSTabNavigationBar class]]) {
        
        MSSTabNavigationBar *navigationBar = (MSSTabNavigationBar *)self.navigationController.navigationBar;
        
        // update while hidden
        [navigationBar.tabBarView fadeOutInWithHiddenUpdate:^(BOOL animated) {
            
            navigationBar.tabBarDataSource = self;
            navigationBar.tabBarDelegate = self;
            _tabNavigationBar = navigationBar;
            
            MSSTabBarView *tabBarView = navigationBar.tabBarView;
            _tabBarView = tabBarView;
            tabBarView.defaultTabIndex = (self.currentPage != self.defaultPageIndex) ? self.currentPage : self.defaultPageIndex;
            
        } duration:0.5f animated:animated];
        
        [navigationBar tabbedPageViewController:self viewWillAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // if next view controller is not tabbed page view controller update navigation bar
    if (![self.navigationController.visibleViewController isKindOfClass:[MSSTabbedPageViewController class]]) {
        [self.tabNavigationBar tabbedPageViewController:self viewWillDisappear:animated];
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
    if (index != self.currentPage) {
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
    self.userInteractionEnabled = YES;
    self.tabBarView.userInteractionEnabled = YES;
}

@end
