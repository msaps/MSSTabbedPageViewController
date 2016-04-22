//
//  MSSTabBarCollectionViewCell+Private.h
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 11/04/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSTabStyle.h"
#import "MSSTabBarCollectionViewCell.h"

@interface MSSTabBarCollectionViewCell ()

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat selectionProgress;

- (void)setTabStyle:(MSSTabStyle)tabStyle;

- (void)setContentBottomMargin:(CGFloat)contentBottomMargin;

@end
