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

- (void)mss_addToParentViewController:(UIViewController *)parentViewController {
    [self mss_addToParentViewController:parentViewController atZIndex:MSSViewDefaultZIndex];
}

- (void)mss_addToParentViewController:(UIViewController *)parentViewController atZIndex:(NSInteger)index {
    [self mss_addToParentViewController:parentViewController withView:parentViewController.view atZIndex:index];
}

- (void)mss_addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view {
    [self mss_addToParentViewController:parentViewController withView:view atZIndex:MSSViewDefaultZIndex];
}

- (void)mss_addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view atZIndex:(NSInteger)index {
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    
    [parentViewController addChildViewController:self];
    [view mss_addExpandingSubview:self.view edgeInsets:UIEdgeInsetsZero atZIndex:index];
    [self didMoveToParentViewController:parentViewController];
}

@end
