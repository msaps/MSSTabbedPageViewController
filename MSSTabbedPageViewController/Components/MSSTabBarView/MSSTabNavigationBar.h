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

@end
