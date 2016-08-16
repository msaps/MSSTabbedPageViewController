//
//  UIView+MSSAutoLayout.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const MSSViewDefaultZIndex;

@interface UIView (MSSAutoLayout)

- (void)mss_addExpandingSubview:(UIView *)subview;

- (void)mss_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets;

- (void)mss_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index;

- (void)mss_addPinnedToTopAndSidesSubview:(UIView *)subview withHeight:(CGFloat)height;

- (void)mss_clearSubviews;

@end
