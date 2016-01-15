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

@class MSSTabbedPageViewController;

@protocol MSSTabbedPageViewControllerDataSource <MSSPageViewControllerDataSource, MSSTabBarViewDataSource>
@end

@protocol MSSTabbedPageViewControllerDelegate <NSObject>
@optional

/**
 The desired tab bar height in the tabbed page view controller.
 
 @param tabbedPageViewController
 The tabbed page view controller.
 @return The tab bar height.
 */
- (CGFloat)tabbedPageViewControllerHeightForTabBar:(MSSTabbedPageViewController *)tabbedPageViewController;

@end

@interface MSSTabbedPageViewController : UIViewController <MSSTabbedPageViewControllerDataSource, MSSTabbedPageViewControllerDelegate>

/**
 The object that acts as a data source for the page view controller and tab bar view.
 */
@property (nonatomic, weak) id<MSSTabbedPageViewControllerDataSource> dataSource;

/**
 The object that acts as a delegate for the page view controller and tab bar view.
 */
@property (nonatomic, weak) id<MSSTabbedPageViewControllerDelegate> delegate;

/**
 The page view controller.
 */
@property (nonatomic, strong, readonly) MSSPageViewController *pageViewController;

/**
 The tab bar view.
 */
@property (nonatomic, strong, readonly) MSSTabBarView *tabBarView;

@end

@protocol MSSTabbedPageChildViewController <MSSPageChildViewController>

/**
 The tab bar view of the parent tabbed page view controller.
 */
@property (nonatomic, weak) MSSTabBarView *tabBarView;

/**
 The required content inset for the child view controller to display correctly in the tabbed page view controller
 */
@property (nonatomic, assign) UIEdgeInsets requiredContentInset;

@end