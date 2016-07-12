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
            CGFloat heightIncrease = self.heightIncreaseRequired ? [self getHeightIncreaseValue] : 0.0f;
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarHidden ? 0.0f : statusBarFrame.size.height;
            
            if (!CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
                frame.origin.y = bounds.origin.y + heightIncrease - statusBarHeight;
                frame.size.height = bounds.size.height + statusBarHeight;
            } else {
                frame.origin.y = -statusBarHeight;
                frame.size.height = bounds.size.height + statusBarHeight + heightIncrease;
            }
            
            [view setFrame:frame];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize originalSize = [super sizeThatFits:size];
    
    // if a transform is active always account for the height increase
    if (!CGAffineTransformIsIdentity(self.transform)) {
        originalSize.height += [self heightIncreaseValue];
    } else {
        originalSize.height += [self getHeightIncreaseValue];
    }
    
    return originalSize;
}

#pragma mark - Public

- (CGFloat)heightIncreaseValue {
    return 0.0f;
}

- (BOOL)heightIncreaseRequired {
    return YES;
}

- (void)setOffsetTransformRequired:(BOOL)required {
    if (required) {
        [self setTransform:CGAffineTransformMakeTranslation(0, -([self heightIncreaseValue]))];
    } else {
        [self setTransform:CGAffineTransformIdentity];
    }
}

#pragma mark - Internal

- (CGFloat)getHeightIncreaseValue {
    if (self.heightIncreaseRequired) {
        return [self heightIncreaseValue];
    }
    return 0.0f;
}

@end
