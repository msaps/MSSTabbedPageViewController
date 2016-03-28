//
//  MSSTabbedPageViewController.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSPageViewController.h"
#import "MSSTabNavigationBar.h"

@interface MSSTabbedPageViewController : MSSPageViewController <MSSTabBarViewDataSource, MSSTabBarViewDelegate>

@property (nonatomic, weak, readonly) MSSTabBarView *tabBarView;

@end

@protocol MSSTabbedPageChildViewController <MSSPageChildViewController>

/**
 The tab bar view of the parent tabbed page view controller.
 */
@property (nonatomic, weak) MSSTabBarView *tabBarView;

@end
