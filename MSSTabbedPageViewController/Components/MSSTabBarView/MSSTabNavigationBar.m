//
//  MSSTabNavigationBar.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabNavigationBar.h"

@interface MSSTabNavigationBar () <MSSTabBarViewDelegate, MSSTabBarViewDataSource>

@end

@implementation MSSTabNavigationBar

#pragma mark - Init

- (void)baseInit {
    [super baseInit];
    
    MSSTabBarView *tabBarView = [MSSTabBarView new];
    tabBarView.dataSource = self;
    tabBarView.delegate = self;
    [self addSubview:tabBarView];
    _tabBarView = tabBarView;
    
    
}

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tabBarHeight = [self requiredHeightIncrease];
    self.tabBarView.frame = CGRectMake(0.0f,
                                       self.bounds.size.height,
                                       self.bounds.size.width,
                                       tabBarHeight);
}

- (CGFloat)requiredHeightIncrease {
    return MSSTabBarViewDefaultHeight;
}

#pragma mark - Public

- (void)setTabBarDataSource:(id<MSSTabBarViewDataSource>)tabBarDataSource {
    self.tabBarView.dataSource = tabBarDataSource;
}

- (id<MSSTabBarViewDataSource>)tabBarDataSource {
    return self.tabBarView.dataSource;
}

- (void)setTabBarDelegate:(id<MSSTabBarViewDelegate>)tabBarDelegate {
    self.tabBarView.delegate = tabBarDelegate;
}

- (id<MSSTabBarViewDelegate>)tabBarDelegate {
    return self.tabBarView.delegate;
}

#pragma mark - Tab Bar data source

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return nil;
}

@end
