//
//  UIView+MSSAnimations.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 29/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MSSAnimations)

- (void)fadeOutInWithHiddenUpdate:(void (^) (BOOL animated))hiddenUpdate duration:(CGFloat)duration animated:(BOOL)animated;

@end
