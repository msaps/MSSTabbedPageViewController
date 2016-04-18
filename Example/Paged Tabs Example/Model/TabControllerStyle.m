//
//  TabControllerStyle.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 11/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "TabControllerStyle.h"

@implementation TabControllerStyle

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(MSSTabStyle)tabStyle
                  sizingStyle:(MSSTabSizingStyle)sizingStyle
                 numberOfTabs:(NSInteger)numberOfTabs {
    return [[self class]styleWithName:name
                             tabStyle:tabStyle
                          sizingStyle:sizingStyle
                      transitionStyle:MSSTabTransitionStyleProgressive
                         numberOfTabs:numberOfTabs];
}

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(MSSTabStyle)tabStyle
                  sizingStyle:(MSSTabSizingStyle)sizingStyle
              transitionStyle:(MSSTabTransitionStyle)transitionStyle
                 numberOfTabs:(NSInteger)numberOfTabs {
    return [[[self class]alloc]initWithName:name
                                   tabStyle:tabStyle
                                sizingStyle:sizingStyle
                            transitionStyle:transitionStyle
                               numberOfTabs:numberOfTabs];
}

- (instancetype)initWithName:(NSString *)name
                    tabStyle:(MSSTabStyle)tabStyle
                     sizingStyle:(MSSTabSizingStyle)sizingStyle
transitionStyle:(MSSTabTransitionStyle)transitionStyle
                    numberOfTabs:(NSInteger)numberOfTabs {
    
    if (self = [super init]) {
        _name = name;
        _tabStyle = tabStyle;
        _sizingStyle = sizingStyle;
        _numberOfTabs = numberOfTabs;
        _transitionStyle = transitionStyle;
    }
    return self;
}

@end
