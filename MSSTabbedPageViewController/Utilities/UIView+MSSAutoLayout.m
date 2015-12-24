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
    if (subview.superview) {
        [subview removeFromSuperview];
    }
    
    [self addSubview:subview];
    subview.translatesAutoresizingMaskIntoConstraints = NO;
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

@end
