//
//  ViewController.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "ChildViewController.h"

@implementation ChildViewController

@synthesize pageViewController;
@synthesize pageIndex;
@synthesize tabBarView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Page %li", self.pageIndex + 1];
}

@end
