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
- (void)pageViewController:(MSSPageViewController *)pageViewController didScrollToPageOffset:(CGFloat)pageOffset;

- (void)pageViewController:(MSSPageViewController *)pageViewController didScrollToPage:(NSInteger)page;

@end

@protocol MSSPageViewControllerDataSource <NSObject>

- (NSArray *)viewControllersForPageViewController:(MSSPageViewController *)tabbedPageViewController;

@optional
- (NSInteger)defaultPageIndexForPageViewController:(MSSPageViewController *)tabbedPageViewController;

@end

@interface MSSPageViewController : UIViewController

@property (nonatomic, weak) id<MSSPageViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<MSSPageViewControllerDelegate> delegate;

/*
 * @brief The number of pages in the page view controller
 */
@property (nonatomic, assign ,readonly) NSInteger numberOfPages;

/*
 * @brief The view controllers within the page view controller
 */
@property (nonatomic, strong, readonly) NSArray *viewControllers;

/*
 * @brief Whether page view controller will provide scroll updates when out of bounds
 */
@property (nonatomic, assign, getter=willNotifyOutOfBoundUpdates) BOOL notifyOutOfBoundUpdates;

/*
 * @brief Whether page view controller will display the current page indicator view
 */
@property (nonatomic, assign) BOOL showPageIndicator;

@end
