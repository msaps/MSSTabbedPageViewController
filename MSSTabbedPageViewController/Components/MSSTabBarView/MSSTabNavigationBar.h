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

@property (nonatomic, strong, readonly) MSSTabBarView *tabBarView;

@property (nonatomic, weak) IBOutlet id<MSSTabBarViewDataSource> tabBarDataSource;
@property (nonatomic, weak) IBOutlet id<MSSTabBarViewDelegate> tabBarDelegate;

@end
