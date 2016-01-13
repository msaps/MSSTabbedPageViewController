//
//  UIViewController+MSSUtilities.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "UIViewController+MSSUtilities.h"
#import "UIView+MSSAutoLayout.h"

@implementation UIViewController (MSSUtilities)

- (void)addToParentViewController:(UIViewController *)parentViewController {
    [self addToParentViewController:parentViewController withView:parentViewController.view];
}

- (void)addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view {
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    
    [parentViewController addChildViewController:self];
    [view addExpandingSubview:self.view];
    [self didMoveToParentViewController:parentViewController];
}

- (CGFloat)requiredTopMargin {
    CGFloat inset = 0.0f;
    
    if (![[UIApplication sharedApplication]isStatusBarHidden]) {
        inset += [[UIApplication sharedApplication]statusBarFrame].size.height;
    }
    
    if (self.navigationController.navigationBar && !self.navigationController.navigationBarHidden) {
        inset += self.navigationController.navigationBar.frame.size.height;
    }
    
    return inset;
}

@end
