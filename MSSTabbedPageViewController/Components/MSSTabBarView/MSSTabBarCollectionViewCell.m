//
//  MSSTabBarCollectionViewCell.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 13/01/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSTabBarCollectionViewCell.h"
#import "MSSTabBarCollectionViewCell+Private.h"

@interface MSSTabBarCollectionViewCell () {
    BOOL _isSelected;
}

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
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
	self.titleLabel.font = textFont;
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
    
    BOOL isSelected = (selectionProgress == 1.0f);
    if (_isSelected != isSelected) { // update selected state
        
        if (self.selectedTextFont || self.selectedTextColor) {
            [UIView transitionWithView:self
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:
             ^{
                 if (self.selectedTextColor) {
                     self.titleLabel.textColor = isSelected ? self.selectedTextColor : self.textColor;
                 }
                 if (self.selectedTextFont) {
                     self.titleLabel.font = isSelected ? self.selectedTextFont : self.textFont;
                 }
            } completion:nil];
        }
        
        _isSelected = isSelected;
        self.selected = isSelected;
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
