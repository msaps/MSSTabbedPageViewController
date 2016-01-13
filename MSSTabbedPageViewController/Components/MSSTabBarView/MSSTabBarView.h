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

- (NSArray *)tabTitlesForTabBarView:(MSSTabBarView *)tabBarView;

@end

@protocol MSSTabBarViewDelegate <NSObject>

- (void)tabBarView:(MSSTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index;

@end

@interface MSSTabBarView : UIView

@property (nonatomic, weak) id<MSSTabBarViewDataSource> dataSource;

@property (nonatomic, weak) id<MSSTabBarViewDelegate> delegate;

@end
