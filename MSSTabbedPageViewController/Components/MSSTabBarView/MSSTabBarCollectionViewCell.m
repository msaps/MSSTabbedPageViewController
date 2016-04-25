//
//  MSSTabBarCollectionViewCell.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabBarCollectionViewCell.h"
#import "MSSTabBarCollectionViewCell+Private.h"

@interface MSSTabBarCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerViewBottomMargin;

@end

@implementation MSSTabBarCollectionViewCell

#pragma mark - Public

- (void)setTitle:(NSString *)title {
    if (self.tabStyle == MSSTabStyleText) {
        self.titleLabel.text = title;
    }
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTextColor:(UIColor *)textColor {
    self.titleLabel.textColor = textColor;
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (void)setTextFont:(UIFont *)textFont {
	self.titleLabel.font = textFont;
}

- (UIFont *)textFont {
	return self.titleLabel.font;
}

- (void)setImage:(UIImage *)image {
    if (self.tabStyle == MSSTabStyleImage) {
        self.imageView.image = image;
    }
}

- (UIImage *)image {
    return self.imageView.image;
}

#pragma mark - Private

- (void)setSelectionProgress:(CGFloat)selectionProgress {
    _selectionProgress = selectionProgress;
    switch (self.tabStyle) {
        case MSSTabStyleText:
            self.titleLabel.alpha = selectionProgress;
            break;
            
        default:
            break;
    }
}

- (void)setTabStyle:(MSSTabStyle)tabStyle {
    _tabStyle = tabStyle;
    
    switch (tabStyle) {
        case MSSTabStyleText:
            self.imageView.image = nil;
            self.titleLabel.hidden = NO;
            self.imageView.hidden = YES;
            break;
            
        case MSSTabStyleImage:
            self.titleLabel.text = nil;
            self.titleLabel.hidden = YES;
            self.imageView.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)setContentBottomMargin:(CGFloat)contentBottomMargin {
    self.containerViewBottomMargin.constant = contentBottomMargin;
}

@end
