//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"

@implementation TabViewController

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

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return @[@"Page One", @"Page Two", @"Page Three", @"Page Four", @"Page Five"];
}

@end
