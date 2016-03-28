//
//  MSSTabNavigationBar.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabNavigationBar.h"

CGFloat const kMSSTabNavigationBarBottomPadding = 4.0f;

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
    
    CGFloat tabBarHeight = [self requiredHeightIncrease] - kMSSTabNavigationBarBottomPadding;
    self.tabBarView.frame = CGRectMake(0.0f,
                                       self.bounds.size.height,
                                       self.bounds.size.width,
                                       tabBarHeight);
}

- (CGFloat)requiredHeightIncrease {
    return MSSTabBarViewDefaultHeight + kMSSTabNavigationBarBottomPadding;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if (CGRectContainsPoint(self.tabBarView.frame, point)) {
        CGPoint tabBarPoint = [self.tabBarView convertPoint:point fromView:self];
        return [self.tabBarView hitTest:tabBarPoint withEvent:event];
    }
    return [super hitTest:point withEvent:event];
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
