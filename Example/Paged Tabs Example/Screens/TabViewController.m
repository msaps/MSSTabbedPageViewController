//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController () <MSSPageViewControllerDataSource, MSSPageViewControllerDelegate>

@end

@implementation TabViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarView.tabStyle = self.style.tabStyle;
    self.tabBarView.sizingStyle = self.style.sizingStyle;
}

#pragma mark - Page View Controller

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return @[
             [storyboard instantiateViewControllerWithIdentifier:@"viewController1"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController2"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController3"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController4"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController5"]
             ];
}

@end
