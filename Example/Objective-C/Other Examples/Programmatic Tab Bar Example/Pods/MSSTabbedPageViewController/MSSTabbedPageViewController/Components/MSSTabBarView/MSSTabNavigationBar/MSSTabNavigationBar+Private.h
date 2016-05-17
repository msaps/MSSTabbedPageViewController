//
//  MSSTabNavigationBarPrivate.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 28/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabNavigationBar.h"

@class MSSTabbedPageViewController;

@interface MSSTabNavigationBar ()

@property (nonatomic, assign) BOOL tabBarRequired;

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController
                  viewWillAppear:(BOOL)animated
                       isInitial:(BOOL)isInitial;

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController
               viewWillDisappear:(BOOL)animated;

@end