//
//  MSSTabNavigationBar.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabNavigationBar.h"
#import "MSSTabNavigationBar+Private.h"

CGFloat const kMSSTabNavigationBarLayoutParameterInvalid = -1.0f;
CGFloat const kMSSTabNavigationBarBottomPadding = 4.0f;

@interface MSSTabNavigationBar () <MSSTabBarViewDelegate, MSSTabBarViewDataSource>

@property (nonatomic, weak) MSSTabbedPageViewController *activeTabbedPageViewController;

@end

@implementation MSSTabNavigationBar

@synthesize tabBarHeight = _tabBarHeight;
@synthesize tabBarBottomPadding = _tabBarBottomPadding;

#pragma mark - Init

- (void)baseInit {
    [super baseInit];
    
    _tabBarHeight = kMSSTabNavigationBarLayoutParameterInvalid;
    _tabBarBottomPadding = kMSSTabNavigationBarLayoutParameterInvalid;
    
    MSSTabBarView *tabBarView = [MSSTabBarView new];
    tabBarView.dataSource = self;
    tabBarView.delegate = self;
    tabBarView.tintColor = self.tintColor;
    [self addSubview:tabBarView];
    _tabBarView = tabBarView;
    
    self.tabBarRequired = self.tabBarRequired;
}

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tabBarHeight = [self heightIncreaseValue] - self.tabBarBottomPadding;
    CGFloat yOffset = self.heightIncreaseRequired ? 0.0f : -[self heightIncreaseValue]; // offset y if tab hidden to animate up
    
    self.tabBarView.frame = CGRectMake(0.0f,
                                       self.bounds.size.height + yOffset,
                                       self.bounds.size.width,
                                       tabBarHeight);
}

- (CGFloat)heightIncreaseValue {
    return self.tabBarHeight + self.tabBarBottomPadding;
}

- (BOOL)heightIncreaseRequired {
    return self.tabBarRequired;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if (CGRectContainsPoint(self.tabBarView.frame, point) && self.tabBarView.userInteractionEnabled && self.tabBarRequired) {
        CGPoint tabBarPoint = [self.tabBarView convertPoint:point fromView:self];
        return [self.tabBarView hitTest:tabBarPoint withEvent:event];
    }
    
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView;
}

#pragma mark - Public

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.tabBarView.tintColor = tintColor;
}

- (void)setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    [super setTitleTextAttributes:titleTextAttributes];
    
    UIColor *foregroundColor = nil;
    if ((foregroundColor = titleTextAttributes[NSForegroundColorAttributeName])) {
        NSMutableDictionary *tabAttributes = self.tabBarView.tabAttributes ? [self.tabBarView.tabAttributes mutableCopy] : [NSMutableDictionary new];
        [tabAttributes setObject:foregroundColor forKey:MSSTabTextColor];
        self.tabBarView.tabAttributes = tabAttributes;
    }
}

- (void)setTabBarHeight:(CGFloat)tabBarHeight {
    _tabBarHeight = tabBarHeight;
    [self setNeedsLayout];
}

- (CGFloat)tabBarHeight {
    if (_tabBarHeight == kMSSTabNavigationBarLayoutParameterInvalid) {
        return MSSTabBarViewDefaultHeight;
    }
    return _tabBarHeight;
}

- (void)setTabBarBottomPadding:(CGFloat)tabBarBottomPadding {
    _tabBarBottomPadding = tabBarBottomPadding;
    [self setNeedsLayout];
}

- (CGFloat)tabBarBottomPadding {
    if (_tabBarBottomPadding == kMSSTabNavigationBarLayoutParameterInvalid) {
        return kMSSTabNavigationBarBottomPadding;
    }
    return _tabBarBottomPadding;
}

#pragma mark - Private

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController viewWillAppear:(BOOL)animated isInitial:(BOOL)isInitial {
    _activeTabbedPageViewController = tabbedPageViewController;
    
    [self setOffsetTransformRequired:isInitial];
    [self setTabBarRequired:YES animated:animated];
}

- (void)tabbedPageViewController:(MSSTabbedPageViewController *)tabbedPageViewController viewWillDisappear:(BOOL)animated {
    if (tabbedPageViewController == self.activeTabbedPageViewController) {
         [self setTabBarRequired:NO animated:animated];
    }
}

- (void)setTabBarRequired:(BOOL)tabBarRequired {
    _tabBarRequired = tabBarRequired;
    self.tabBarView.alpha = tabBarRequired;
    self.tabBarView.userInteractionEnabled = tabBarRequired;
}

#pragma mark - Internal

- (void)setTabBarRequired:(BOOL)required animated:(BOOL)animated {
    if (self.tabBarRequired != required) {
        
        // show or hide tab bar view
        void (^tabVisiblityBlock)() = ^void() {
            self.tabBarRequired = required;
            [self layoutIfNeeded];
        };
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                tabVisiblityBlock();
            }];
        } else {
            tabVisiblityBlock();
        }
    }
}

#pragma mark - Tab Bar data source

- (NSInteger)numberOfItemsForTabBarView:(MSSTabBarView *)tabBarView {
    return 0;
}

- (void)tabBarView:(MSSTabBarView *)tabBarView
       populateTab:(MSSTabBarCollectionViewCell *)tab
           atIndex:(NSInteger)index {
    
}

@end
