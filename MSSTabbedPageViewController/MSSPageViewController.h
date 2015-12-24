//
//  MSSTabbedPageViewController.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (nonatomic, strong, readonly) NSArray *viewControllers;

@end
