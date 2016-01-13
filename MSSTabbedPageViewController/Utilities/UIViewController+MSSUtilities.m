//
//  UIViewController+MSSUtilities.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "UIViewController+MSSUtilities.h"

@implementation UIViewController (MSSUtilities)

- (void)addToParentViewController:(UIViewController *)parentViewController {
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:parentViewController];
}

@end
