//
//  MSSTabBarAppearance.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 03/06/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const _Nonnull MSSTabTextColor __attribute__((deprecated("Use NSForegroundColorAttributeName instead")));
extern NSString *const _Nonnull MSSTabTextFont __attribute__((deprecated("Use NSFontAttributeName instead")));
/**
 The alpha value for the tab title label.
 */
extern NSString *const _Nonnull MSSTabTitleAlpha;

/**
 The height of the tab indicator line.
 */
extern NSString *const _Nonnull MSSTabIndicatorLineHeight;
/**
 The image to use for the tab indicator.
 */
extern NSString *const _Nonnull MSSTabIndicatorImage;
/**
 The tint color to use for the tab indicator image.
 */
extern NSString *const _Nonnull MSSTabIndicatorImageTintColor;

/**
 Whether the crossfading alpha effect is enabled for tab transitions.
 */
extern NSString *const _Nonnull MSSTabTransitionAlphaEffectEnabled;