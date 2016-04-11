//
//  TabControllerStyle.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 11/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSTabBarView.h"

@interface TabControllerStyle : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) MSSTabStyle tabStyle;
@property (nonatomic, assign) MSSTabSizingStyle sizingStyle;
@property (nonatomic, assign) NSInteger numberOfTabs;

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(MSSTabStyle)tabStyle
                      sizingStyle:(MSSTabSizingStyle)sizingStyle
                     numberOfTabs:(NSInteger)numberOfTabs;

@end
