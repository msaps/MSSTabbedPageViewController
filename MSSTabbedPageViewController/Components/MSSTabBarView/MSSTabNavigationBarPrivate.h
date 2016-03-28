//
//  MSSTabNavigationBarPrivate.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 28/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

@class MSSTabbedPageViewController;

@interface MSSTabNavigationBar ()

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController viewWillAppear:(BOOL)animated;

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController viewWillDisappear:(BOOL)animated;

@end