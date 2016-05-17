//
//  MSSTabNavigationBar.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSCustomHeightNavigationBar.h"
#import "MSSTabBarView.h"

@interface MSSTabNavigationBar : MSSCustomHeightNavigationBar

/**
 The tab bar view in the navigation bar.
 */
@property (nonatomic, strong, readonly) MSSTabBarView *tabBarView;

/**
 The height for the tab bar in the navigation bar.
 
 Default: 44px.
 */
@property (nonatomic, assign) IBInspectable CGFloat tabBarHeight;
/**
 The padding to use between the bottom of the tab bar and navigation bar.
 
 Default: 4px.
 */
@property (nonatomic, assign) IBInspectable CGFloat tabBarBottomPadding;

@end
