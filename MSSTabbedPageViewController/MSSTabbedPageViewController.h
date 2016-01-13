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

@interface MSSTabbedPageViewController : UIViewController <MSSPageViewControllerDelegate, MSSTabbedPageViewControllerDataSource>

@property (nonatomic, strong, readonly) MSSPageViewController *pageViewController;

@property (nonatomic, strong, readonly) MSSTabBarView *tabBarView;

@end
