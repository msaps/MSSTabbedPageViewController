//
//  UIViewController+MSSUtilities.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MSSUtilities)

- (void)mss_addToParentViewController:(UIViewController *)parentViewController;

- (void)mss_addToParentViewController:(UIViewController *)parentViewController atZIndex:(NSInteger)index;

- (void)mss_addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view;

@end
