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

/**
 The tab bar view.
 */
@property (nonatomic, weak, nullable) IBOutlet MSSTabBarView *tabBarView;

@end