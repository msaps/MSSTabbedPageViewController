//
//  UIView+MSSAutoLayout.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "UIView+MSSAutoLayout.h"

@implementation UIView (MSSAutoLayout)

- (void)addExpandingSubview:(UIView *)subview {
    [self addExpandingSubview:subview edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets {
    [self addView:subview];
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-%f-[subview]-%f-|", insets.top, insets.bottom];
    NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-%f-[subview]-%f-|", insets.left, insets.right];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

- (void)addPinnedToTopAndSidesSubview:(UIView *)subview withHeight:(CGFloat)height {
    [self addView:subview];
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    NSDictionary *metrics = @{@"viewHeight":@(height)};
    NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-[subview(viewHeight)]"];
    NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-[subview]-|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - Internal

- (void)addView:(UIView *)subview {
    if (subview.superview) {
        [subview removeFromSuperview];
    }
    [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
