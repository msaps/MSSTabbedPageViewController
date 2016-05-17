//
//  UIViewController+MSSUtilities.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MSSUtilities)

- (void)addToParentViewController:(UIViewController *)parentViewController;

- (void)addToParentViewController:(UIViewController *)parentViewController atZIndex:(NSInteger)index;

- (void)addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view;

- (CGFloat)requiredTopMargin;

@end
