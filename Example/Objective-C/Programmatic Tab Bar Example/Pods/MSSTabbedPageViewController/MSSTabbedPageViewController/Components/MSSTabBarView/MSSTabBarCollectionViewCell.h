//
//  MSSTabBarCollectionViewCell.h
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSTabStyle.h"

@interface MSSTabBarCollectionViewCell : UICollectionViewCell

/**
 The style of the tab.
 */
@property (nonatomic, assign, readonly) MSSTabStyle tabStyle;
/**
 The image displayed in the tab cell.
 
 NOTE - only visible when using MSSTabStyleImage.
 */
@property (nonatomic, strong, nullable) UIImage *image;
/**
 The text displayed in the tab cell.
 
 NOTE - only visible when using MSSTabStyleText.
 */
@property (nonatomic, copy, nullable) NSString *title;

@end
