//
//  MSSTabBarView.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const MSSTabBarViewDefaultHeight;

@class MSSTabBarView;
@protocol MSSTabBarViewDataSource <NSObject>

/**
 The tab titles to display in the tab bar.
 
 @param tabBarView
 The tab bar view.
 @return The array of tab titles.
 */
- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView;

@end

@protocol MSSTabBarViewDelegate <NSObject>

/**
 A tab has been selected.
 
 @param tabBarView
 The tab bar view.
 @param index
 The index of the selected tab.
 */
- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index;

@end

@interface MSSTabBarView : UIView

@property (nonatomic, weak) id<MSSTabBarViewDataSource> dataSource;

@property (nonatomic, weak) id<MSSTabBarViewDelegate> delegate;

/**
 The internal horizontal label padding value for each tab.
 */
@property (nonatomic, assign) CGFloat tabPadding;

/**
 The content inset for the tabs.
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 The current tab offset of the tab bar.
 */
@property (nonatomic, assign) CGFloat tabOffset;

/**
 The expected number of tabs in the tab bar.
 */
@property (nonatomic, assign) NSInteger expectedTabCount;

/**
 The default index for the tab bar to display.
 */
@property (nonatomic, assign) NSInteger defaultTabIndex;

/**
 Whether the tab bar is currently animating a tab change transition.
 */
@property (nonatomic, assign, readonly, getter=isAnimatingTabChange) BOOL animatingTabChange;

/**
 Set the current selected tab index of the tab bar.
 
 @param index
 The index of the current tab.
 @param animated
 Animate the tab index transition.
 */
- (void)setTabIndex:(NSInteger)index animated:(BOOL)animated;

@end
