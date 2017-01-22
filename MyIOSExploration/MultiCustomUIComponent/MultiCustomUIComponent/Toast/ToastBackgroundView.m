//
//  ToastBackgroundView.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ToastBackgroundView.h"

@interface ToastBackgroundView ()

@property(nonatomic, strong) UIView *effectView;

@end

@implementation ToastBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.allowsGroupOpacity = NO;
        
        self.backgroundColor = self.styleColor;
        self.layer.cornerRadius = self.cornerRadius;
        
    }
    return self;
}

- (void)setShouldBlurBackgroundView:(BOOL)shouldBlurBackgroundView {
    _shouldBlurBackgroundView = shouldBlurBackgroundView;
    if (shouldBlurBackgroundView) {
        if (NSClassFromString(@"UIBlurEffect")) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            effectView.layer.cornerRadius = self.cornerRadius;
            effectView.layer.masksToBounds = YES;
            [self addSubview:effectView];
            self.effectView = effectView;
        }
    } else {
        if (self.effectView) {
            [self.effectView removeFromSuperview];
            self.effectView = nil;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.effectView) {
        self.effectView.frame = self.bounds;
    }
}

#pragma mark - UIAppearance

- (void)setStyleColor:(UIColor *)styleColor {
    _styleColor = styleColor;
    self.backgroundColor = styleColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    if (self.effectView) {
        self.effectView.layer.cornerRadius = cornerRadius;
    }
}

@end


@interface ToastBackgroundView (UIAppearance)

@end

@implementation ToastBackgroundView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    ToastBackgroundView *appearance = [ToastBackgroundView appearance];
    appearance.styleColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.8/1.0];
    appearance.cornerRadius = 10.0;
}

@end

