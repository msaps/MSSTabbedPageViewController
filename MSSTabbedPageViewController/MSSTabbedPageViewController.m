//
//  MSSTabbedPageViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "MSSTabbedPageViewController.h"

@interface MSSTabbedPageViewController ()

@property (nonatomic, strong) MSSPageViewController *pageViewController;

@end

@implementation MSSTabbedPageViewController

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    if (!_pageViewController) {
        self.pageViewController = [MSSPageViewController new];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageViewController.parentViewController) {
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
}

#pragma mark - Page View Controller data source

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)tabbedPageViewController {
    return nil;
}

- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)tabbedPageViewController {
    return 0;
}

@end
