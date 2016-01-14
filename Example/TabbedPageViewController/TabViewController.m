//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

#pragma mark - Page View Controller

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return @[
             [storyboard instantiateViewControllerWithIdentifier:@"viewController1"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController2"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController3"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController4"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController5"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewController6"]
             ];
}

- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController {
    return 1;
}

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return @[@"Long Page 1", @"Page 2", @"Longer Page 3"];
}

@end
