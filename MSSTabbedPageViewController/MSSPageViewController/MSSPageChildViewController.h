//
//  MSSPageChildViewController.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 15/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSPageViewController.h"

@class MSSPageViewController;

@protocol MSSPageChildViewController <NSObject>

@property (nonatomic, weak) MSSPageViewController *pageViewController;

@end