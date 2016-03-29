//
//  MSSCustomHeightNavigationBar.m
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 27/03/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

#import "MSSCustomHeightNavigationBar.h"

@implementation MSSCustomHeightNavigationBar

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
    
    [self setTransform:CGAffineTransformMakeTranslation(0, -([self heightIncreaseValue]))];
}

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
            CGFloat heightIncrease = self.heightIncreaseRequired ? [self heightIncreaseValue] : 0.0f;
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarHidden ? 0.0f : statusBarFrame.size.height;
            frame.origin.y = bounds.origin.y + heightIncrease - statusBarHeight;
            frame.size.height = bounds.size.height + statusBarHeight;
            
            [view setFrame:frame];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize originalSize = [super sizeThatFits:size];
    originalSize.height += self.heightIncreaseRequired ? [self heightIncreaseValue] : 0.0f;
    
    return originalSize;
}

- (CGFloat)heightIncreaseValue {
    return 44;
}

- (BOOL)heightIncreaseRequired {
    return YES;
}

@end
