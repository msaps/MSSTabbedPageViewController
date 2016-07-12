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

@property (nonatomic, weak) IBOutlet UIView *textContainerView;
@property (nonatomic, weak) IBOutlet UILabel *textTitleLabel;

@property (nonatomic, weak) IBOutlet UIView *imageContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *imageImageView;

@property (nonatomic, weak) IBOutlet UIView *imageTextContainerView;
@property (nonatomic, weak) IBOutlet UILabel *imageTextTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageTextImageView;

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
    self.textTitleLabel.text = title;
    self.imageTextTitleLabel.text = title;
}

- (NSString *)title {
    return self.textTitleLabel.text;
}

- (void)setImage:(UIImage *)image {
    if (self.tabStyle == MSSTabStyleImage || self.tabStyle == MSSTabStyleImageAndText) {
        self.imageImageView.image = image;
        self.imageTextImageView.image = image;
    }
}

- (UIImage *)image {
    return self.imageImageView.image;
}

#pragma mark - Private

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (!_isSelected) {
        self.textTitleLabel.textColor = textColor;
        self.imageTextTitleLabel.textColor = textColor;
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    if (_isSelected) {
        self.textTitleLabel.textColor = selectedTextColor;
        self.imageTextTitleLabel.textColor = selectedTextColor;
    }
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    if (!_isSelected) {
        self.textTitleLabel.font = textFont;
        self.imageTextTitleLabel.font = textFont;
    }
}

- (void)setSelectedTextFont:(UIFont *)selectedTextFont {
    _selectedTextFont = selectedTextFont;
    if (_isSelected) {
        self.textTitleLabel.font = selectedTextFont;
        self.imageTextTitleLabel.font = selectedTextFont;
    }
}

- (void)setTabStyle:(MSSTabStyle)tabStyle {
    _tabStyle = tabStyle;
    
    switch (tabStyle) {
        case MSSTabStyleImageAndText:
            self.textContainerView.hidden = YES;
            self.imageContainerView.hidden = YES;
            self.imageTextContainerView.hidden = NO;
            break;
            
        case MSSTabStyleImage:
            self.textContainerView.hidden = YES;
            self.imageContainerView.hidden = NO;
            self.imageTextContainerView.hidden = YES;
            break;
            
        default:
            self.textContainerView.hidden = NO;
            self.imageContainerView.hidden = YES;
            self.imageTextContainerView.hidden = YES;
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
        self.textTitleLabel.alpha = 1.0f;
        self.imageTextTitleLabel.alpha = 1.0f;
    }
}

#pragma mark - Internal

- (void)updateProgressiveAppearance {
    switch (self.tabStyle) {
        case MSSTabStyleText:
        case MSSTabStyleImageAndText:
            if (self.alphaEffectEnabled) {
                self.textTitleLabel.alpha = self.selectionProgress;
                self.imageTextTitleLabel.alpha = self.selectionProgress;
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
                     UIColor *textColor = isSelected ? self.selectedTextColor : self.textColor;
                     self.textTitleLabel.textColor = textColor;
                     self.imageTextTitleLabel.textColor = textColor;
                 } else {
                     self.textTitleLabel.textColor = self.textColor;
                     self.imageTextTitleLabel.textColor = self.textColor;
                 }
                 
                 if (self.selectedTextFont) {
                     UIFont *textFont = isSelected ? self.selectedTextFont : self.textFont;
                     self.textTitleLabel.font = textFont;
                     self.imageTextTitleLabel.font = textFont;
                 } else {
                     self.textTitleLabel.font = self.textFont;
                     self.imageTextTitleLabel.font = self.textFont;
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
