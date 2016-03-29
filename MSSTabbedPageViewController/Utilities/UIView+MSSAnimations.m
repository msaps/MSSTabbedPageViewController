//
//  UIView+MSSAnimations.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 29/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "UIView+MSSAnimations.h"

@implementation UIView (MSSAnimations)

- (void)fadeOutInWithHiddenUpdate:(void (^)(BOOL))hiddenUpdate animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            hiddenUpdate(animated);
            [UIView animateWithDuration:0.3f animations:^{
                self.alpha = 1.0f;
            }];
        }];
    } else {
        self.hidden = YES;
        hiddenUpdate(animated);
        self.hidden = NO;
    }
}

@end
