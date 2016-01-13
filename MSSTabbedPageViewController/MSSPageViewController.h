//
//  MSSTabbedPageViewController.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+MSSUtilities.h"
#import "UIView+MSSAutoLayout.h"

@class MSSPageViewController;

@protocol MSSPageViewControllerDelegate <NSObject>
@optional

/**
 The page view controller has scrolled to a new page offset.
 
 @param pageViewController
        The page view controller.
 @param pageOffset 
        The updated page offset.
 */
- (void)pageViewController:(MSSPageViewController *)pageViewController didScrollToPageOffset:(CGFloat)pageOffset;

/**
 The page view controller has completed scroll to a page.
 
 @param pageViewController
 The page view controller.
 @param page
 The new currently visible page.
 */
- (void)pageViewController:(MSSPageViewController *)pageViewController didScrollToPage:(NSInteger)page;

@end

@protocol MSSPageViewControllerDataSource <NSObject>

/**
 The view controllers to display in the page view controller.
 
 @param pageViewController
 The page view controller.
 @return The array of view controllers.
 */
- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)pageViewController;

@optional

/**
 The default page index for the page view controller to initially display.
 
 @param pageViewController
 The page view controller.
 @return The default page index.
 */
- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)pageViewController;

@end

@interface MSSPageViewController : UIViewController

@property (nonatomic, weak) id<MSSPageViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<MSSPageViewControllerDelegate> delegate;

/**
 The number of pages in the page view controller.
 */
@property (nonatomic, assign ,readonly) NSInteger numberOfPages;

/** 
 The view controllers within the page view controller.
 */
@property (nonatomic, strong, readonly) NSArray *viewControllers;

/**  
 Whether page view controller will provide scroll updates when out of bounds.
 */
@property (nonatomic, assign, getter=willNotifyOutOfBoundUpdates) BOOL notifyOutOfBoundUpdates;

/** 
 Whether page view controller will display the page indicator view.
 */
@property (nonatomic, assign) BOOL showPageIndicator;

@end
