//
//  MSSTabNavigationBar.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabNavigationBar.h"
#import "MSSTabNavigationBarPrivate.h"

CGFloat const kMSSTabNavigationBarBottomPadding = 4.0f;

@interface MSSTabNavigationBar () <MSSTabBarViewDelegate, MSSTabBarViewDataSource>

@property (nonatomic, weak) MSSTabbedPageViewController *activeTabbedPageViewController;
@property (nonatomic, assign) BOOL tabBarRequired;

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
    
    CGFloat tabBarHeight = [self heightIncreaseValue] - kMSSTabNavigationBarBottomPadding;
    self.tabBarView.frame = CGRectMake(0.0f,
                                       self.bounds.size.height,
                                       self.bounds.size.width,
                                       tabBarHeight);
}

- (CGFloat)heightIncreaseValue {
    return MSSTabBarViewDefaultHeight + kMSSTabNavigationBarBottomPadding;
}

- (BOOL)heightIncreaseRequired {
    return self.tabBarRequired;
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

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.tabBarView.tabIndicatorColor = tintColor;
}

- (void)setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    [super setTitleTextAttributes:titleTextAttributes];
    
    UIColor *foregroundColor = nil;
    if ((foregroundColor = titleTextAttributes[NSForegroundColorAttributeName])) {
        self.tabBarView.tabTextColor = foregroundColor;
    }
}

#pragma mark - Private

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController viewWillAppear:(BOOL)animated {
    _activeTabbedPageViewController = tabbedPageViewController;
    [self setTabBarVisible:YES animated:animated];
}

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController viewWillDisappear:(BOOL)animated {
    if (tabbedPageViewController == self.activeTabbedPageViewController) {
         [self setTabBarVisible:NO animated:animated];
    }
}

#pragma mark - Internal

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    if (self.tabBarRequired != visible) {
        self.tabBarView.alpha = visible;
        
        self.tabBarRequired = visible;
        [self setNeedsLayout];
    }
}

#pragma mark - Tab Bar data source

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView {
    return nil;
}

@end
