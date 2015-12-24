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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)tabbedPageViewController {
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

@end
