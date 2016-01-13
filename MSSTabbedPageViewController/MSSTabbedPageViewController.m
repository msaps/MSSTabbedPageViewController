//
//  MSSTabbedPageViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"

@interface MSSTabbedPageViewController () <MSSTabBarViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@end

@implementation MSSTabbedPageViewController

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
}

#pragma mark - Page View Controller data source

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    return nil;
}

- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Tab Bar View data source

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return nil;
}

#pragma mark - Tab Bar View delegate

- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    
}

#pragma mark - Internal

- (void)setUpContentView {
    [self.view addExpandingSubview:self.contentView];
    
    UIEdgeInsets margins = self.contentView.layoutMargins;
    margins.top = self.requiredTopMargin;
    self.contentView.layoutMargins = margins;
}

@end
