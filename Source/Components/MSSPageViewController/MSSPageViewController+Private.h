//
//  MSSPageViewControllerPrivate.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 28/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSPageViewController.h"

@interface MSSPageViewController () <UIScrollViewDelegate>

/**
 The default page index of the page view controller.
 */
@property (nonatomic, assign, readonly) NSInteger defaultPageIndex;
/**
 The current active page index of the page view controller.
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 Whether user interaction is currently enabled on the page view controller
 */
@property (nonatomic, assign) BOOL userInteractionEnabled;

- (void)setUpViewController:(nonnull UIViewController *)viewController
                      index:(NSInteger)index;

@end
