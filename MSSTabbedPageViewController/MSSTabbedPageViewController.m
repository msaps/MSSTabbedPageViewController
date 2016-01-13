//
//  MSSTabbedPageViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"

@implementation MSSTabbedPageViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    if (!_pageViewController) {
        _pageViewController = [MSSPageViewController new];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pageViewController addToParentViewController:self];
}
    
#pragma mark - Page View Controller data source

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController {
    return nil;
}

- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController {
    return 0;
}

@end
