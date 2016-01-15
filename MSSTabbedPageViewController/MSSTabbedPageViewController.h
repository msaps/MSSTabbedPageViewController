//
//  MSSTabbedPageViewController.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSPageViewController.h"
#import "MSSTabBarView.h"

@protocol MSSTabbedPageViewControllerDataSource <MSSPageViewControllerDataSource, MSSTabBarViewDataSource>
@end

@interface MSSTabbedPageViewController : UIViewController <MSSTabbedPageViewControllerDataSource>

/**
 The page view controller.
 */
@property (nonatomic, strong, readonly) MSSPageViewController *pageViewController;

/**
 The tab bar view.
 */
@property (nonatomic, strong, readonly) MSSTabBarView *tabBarView;

/**
 The object that acts as a data source for the page view controller and tab bar view.
 */
@property (nonatomic, weak) id<MSSTabbedPageViewControllerDataSource> dataSource;

@end

@protocol MSSTabbedPageChildViewController <MSSPageChildViewController>

/**
 The tab bar view of the parent tabbed page view controller.
 */
@property (nonatomic, weak) MSSTabBarView *tabBarView;

@end