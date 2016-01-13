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
             [storyboard instantiateViewControllerWithIdentifier:@"viewControllerA"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewControllerB"],
             [storyboard instantiateViewControllerWithIdentifier:@"viewControllerC"]
             ];
}

- (void)pageViewController:(MSSPageViewController *)pageViewController didScrollToPageOffset:(CGFloat)pageOffset {
    NSLog(@"%f", pageOffset);
}

- (void)pageViewController:(MSSPageViewController *)pageViewController didScrollToPage:(NSInteger)page {
    NSLog(@"did scroll to page: %li", page);
}

@end
