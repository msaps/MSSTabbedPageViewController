//
//  UIView+MSSAutoLayout.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MSSAutoLayout)

- (void)addExpandingSubview:(UIView *)subview;

- (void)addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets;

- (void)addPinnedToTopAndSidesSubview:(UIView *)subview withHeight:(CGFloat)height;

@end
