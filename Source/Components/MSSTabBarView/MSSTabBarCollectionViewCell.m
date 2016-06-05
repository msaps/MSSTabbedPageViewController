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

#pragma mark - Init


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    _alphaEffectEnabled = YES; // alpha effect enabled by default
}

#pragma mark - Public

- (void)setTitle:(NSString *)title {
    if (self.tabStyle == MSSTabStyleText) {
        self.titleLabel.text = title;
    }
}

- (NSString *)title {
    return self.titleLabel.text;
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

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (!_isSelected) {
        self.titleLabel.textColor = textColor;
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    if (_isSelected) {
        self.titleLabel.textColor = selectedTextColor;
    }
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    if (!_isSelected) {
        self.titleLabel.font = textFont;
    }
}

- (void)setSelectedTextFont:(UIFont *)selectedTextFont {
    _selectedTextFont = selectedTextFont;
    if (_isSelected) {
        self.titleLabel.font = selectedTextFont;
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

- (void)setTabBackgroundColor:(UIColor *)tabBackgroundColor {
    _tabBackgroundColor = tabBackgroundColor;
    if (!_isSelected) {
        self.backgroundColor = tabBackgroundColor;
    }
}

- (void)setSelectedTabBackgroundColor:(UIColor *)selectedTabBackgroundColor {
    _selectedTabBackgroundColor = selectedTabBackgroundColor;
    if (_isSelected) {
        self.backgroundColor = selectedTabBackgroundColor;
    }
}

- (void)setSelectionProgress:(CGFloat)selectionProgress {
    _selectionProgress = selectionProgress;
    
    [self updateProgressiveAppearance];
    [self updateSelectionAppearance];
}

- (void)setAlphaEffectEnabled:(BOOL)alphaEffectEnabled {
    _alphaEffectEnabled = alphaEffectEnabled;
    if (alphaEffectEnabled) {
        [self updateProgressiveAppearance];
    } else {
        self.titleLabel.alpha = 1.0f;
    }
}

#pragma mark - Internal

- (void)updateProgressiveAppearance {
    switch (self.tabStyle) {
        case MSSTabStyleText:
            if (self.alphaEffectEnabled) {
                self.titleLabel.alpha = self.selectionProgress;
            }
            break;
            
        default:
            break;
    }
}

- (void)updateSelectionAppearance {
    BOOL isSelected = (self.selectionProgress == 1.0f);
    if (_isSelected != isSelected) { // update selected state
        
        if (self.selectedTextFont || self.selectedTextColor) {
            [UIView transitionWithView:self
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:
             ^{
                 if (self.selectedTextColor) {
                     self.titleLabel.textColor = isSelected ? self.selectedTextColor : self.textColor;
                 } else {
                     self.titleLabel.textColor = self.textColor;
                 }
                 
                 if (self.selectedTextFont) {
                     self.titleLabel.font = isSelected ? self.selectedTextFont : self.textFont;
                 } else {
                     self.titleLabel.font = self.textFont;
                 }
                 
                 if (self.selectedTabBackgroundColor) {
                     self.backgroundColor = isSelected ? self.selectedTabBackgroundColor : self.tabBackgroundColor;
                 } else {
                     self.backgroundColor = self.tabBackgroundColor;
                 }
                 
             } completion:nil];
        }
        
        _isSelected = isSelected;
        self.selected = isSelected;
    }
}

@end
