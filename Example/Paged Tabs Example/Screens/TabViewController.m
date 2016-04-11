//
//  TabViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "TabViewController.h"
#import "ChildViewController.h"

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
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    for (NSInteger i = 0; i < self.style.numberOfTabs; i++) {
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"viewController1"];
        [viewControllers addObject:viewController];
    }
    return viewControllers;
}

- (void)tabBarView:(MSSTabBarView *)tabBarView populateTab:(MSSTabBarCollectionViewCell *)tab atIndex:(NSInteger)index {
    NSString *imageName = [NSString stringWithFormat:@"tab%i.png", (index + 1)];
    NSString *pageName = [NSString stringWithFormat:@"Page %i", (index + 1)];
    
    tab.image = [UIImage imageNamed:imageName];
    tab.title = pageName;
}

@end
