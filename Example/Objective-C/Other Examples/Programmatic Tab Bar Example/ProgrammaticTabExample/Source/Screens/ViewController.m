//
//  ViewController.m
//  TabTest
//
//  Created by Merrick Sapsford on 09/05/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "ViewController.h"
#import <PureLayout/PureLayout.h>

@interface ViewController () {
    MSSTabBarView *_tabBarView; // creating the tab bar in code - (self.tabBarView is weak)
}
@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create tab bar
    _tabBarView = [MSSTabBarView new];
    self.tabBarView = _tabBarView;
    
    [self.view addSubview:self.tabBarView];
    [self.tabBarView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f) excludingEdge:ALEdgeBottom];
    [self.tabBarView autoSetDimension:ALDimensionHeight toSize:44.0f];
    
    // set up tab bar
    self.tabBarView = _tabBarView;
    self.tabBarView.delegate = self;
    self.tabBarView.dataSource = self;
}

#pragma mark - MSSPageViewControllerDataSource

- (NSArray<UIViewController *> *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return @[[storyboard instantiateViewControllerWithIdentifier:@"viewControllerA"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewControllerB"]];
}

@end
