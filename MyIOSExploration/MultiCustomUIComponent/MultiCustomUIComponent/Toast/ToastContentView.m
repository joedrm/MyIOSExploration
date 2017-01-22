//
//  ToastContentView.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ToastContentView.h"
#import "CommonDefines.h"

#define DefaultTextLabelFont [UIFont systemFontOfSize:16]
#define DefaultDetailTextLabelFont [UIFont systemFontOfSize:12]
#define DefaultLabelColor [UIColor whiteColor]


@implementation ToastContentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.allowsGroupOpacity = NO;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = DefaultLabelColor;
    self.textLabel.font = DefaultTextLabelFont;
    self.textLabel.opaque = NO;
    [self addSubview:self.textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.textColor = DefaultLabelColor;
    self.detailTextLabel.font = DefaultDetailTextLabelFont;
    self.detailTextLabel.opaque = NO;
    [self addSubview:self.detailTextLabel];
}

- (void)setCustomView:(UIView *)customView {
    if (self.customView) {
        [self.customView removeFromSuperview];
        _customView = nil;
    }
    _customView = customView;
    [self addSubview:self.customView];
    [self updateCustomViewTintColor];
    [self setNeedsLayout];
}

- (void)setTextLabelText:(NSString *)textLabelText {
    _textLabelText = textLabelText;
    if (textLabelText) {
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:textLabelText attributes:self.textLabelAttributes];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self setNeedsLayout];
    }
}

- (void)setDetailTextLabelText:(NSString *)detailTextLabelText {
    _detailTextLabelText = detailTextLabelText;
    if (detailTextLabelText) {
        self.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:detailTextLabelText attributes:self.detailTextLabelAttributes];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    BOOL hasCustomView = !!self.customView;
    BOOL hasTextLabel = self.textLabel.text.length > 0;
    BOOL hasDetailTextLabel = self.detailTextLabel.text.length > 0;
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    CGFloat maxContentWidth = size.width - UIEdgeInsetsGetHorizontalValue(self.insets);
    CGFloat maxContentHeight = size.height - UIEdgeInsetsGetVerticalValue(self.insets);
    
    if (hasCustomView) {
        width = fmaxf(width, CGRectGetWidth(self.customView.bounds));
        height += (CGRectGetHeight(self.customView.bounds) + ((hasTextLabel || hasDetailTextLabel) ? self.customViewMarginBottom : 0));
    }
    
    if (hasTextLabel) {
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(maxContentWidth, maxContentHeight)];
        width = fmaxf(width, textLabelSize.width);
        height += (textLabelSize.height + (hasDetailTextLabel ? self.textLabelMarginBottom : 0));
    }
    
    if (hasDetailTextLabel) {
        CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:CGSizeMake(maxContentWidth, maxContentHeight)];
        width = fmaxf(width, detailTextLabelSize.width);
        height += (detailTextLabelSize.height + self.detailTextLabelMarginBottom);
    }
    
    width += UIEdgeInsetsGetHorizontalValue(self.insets);
    height += UIEdgeInsetsGetVerticalValue(self.insets);
    
    if (!CGSizeEqualToSize(self.minimumSize, CGSizeZero)) {
        width = fmaxf(width, self.minimumSize.width);
        height = fmaxf(height, self.minimumSize.height);
    }
    
    return CGSizeMake(fminf(size.width, width), fminf(size.height, height));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL hasCustomView = !!self.customView;
    BOOL hasTextLabel = self.textLabel.text.length > 0;
    BOOL hasDetailTextLabel = self.detailTextLabel.text.length > 0;
    
    CGFloat contentWidth = CGRectGetWidth(self.bounds);
    CGFloat maxContentWidth = contentWidth - UIEdgeInsetsGetHorizontalValue(self.insets);
    
    CGFloat minY = self.insets.top;
    
    if (hasCustomView) {
        if (!hasTextLabel && !hasDetailTextLabel) {
            // 处理有minimumSize的情况
            minY = CGFloatGetCenter(CGRectGetHeight(self.bounds), CGRectGetHeight(self.customView.bounds));
        }
        self.customView.frame = CGRectFlatMake(CGFloatGetCenter(contentWidth, CGRectGetWidth(self.customView.bounds)), minY, CGRectGetWidth(self.customView.bounds), CGRectGetHeight(self.customView.bounds));
        minY = CGRectGetMaxY(self.customView.frame) + self.customViewMarginBottom;
    }
    
    if (hasTextLabel) {
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(maxContentWidth, CGFLOAT_MAX)];
        if (!hasCustomView && !hasDetailTextLabel) {
            // 处理有minimumSize的情况
            minY = CGFloatGetCenter(CGRectGetHeight(self.bounds), textLabelSize.height);
        }
        self.textLabel.frame = CGRectFlatMake(CGFloatGetCenter(contentWidth, maxContentWidth), minY, maxContentWidth, textLabelSize.height);
        minY = CGRectGetMaxY(self.textLabel.frame) + self.textLabelMarginBottom;
    }
    
    if (hasDetailTextLabel) {
        // 暂时没考虑剩余高度不够用的情况
        CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:CGSizeMake(maxContentWidth, CGFLOAT_MAX)];
        if (!hasCustomView && !hasTextLabel) {
            // 处理有minimumSize的情况
            minY = CGFloatGetCenter(CGRectGetHeight(self.bounds), detailTextLabelSize.height);
        }
        self.detailTextLabel.frame = CGRectFlatMake(CGFloatGetCenter(contentWidth, maxContentWidth), minY, maxContentWidth, detailTextLabelSize.height);
    }
}

- (void)tintColorDidChange {
    
    if (self.customView) {
        [self updateCustomViewTintColor];
    }
    
    NSMutableDictionary *textLabelAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.textLabelAttributes];
    textLabelAttributes[NSForegroundColorAttributeName] = self.tintColor;
    self.textLabelAttributes = textLabelAttributes;
    self.textLabelText = self.textLabelText;
    
    NSMutableDictionary *detailTextLabelAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.detailTextLabelAttributes];
    detailTextLabelAttributes[NSForegroundColorAttributeName] = self.tintColor;
    self.detailTextLabelAttributes = detailTextLabelAttributes;
    self.detailTextLabelText = self.detailTextLabelText;
}

- (void)updateCustomViewTintColor {
    if (!self.customView) {
        return;
    }
    self.customView.tintColor = self.tintColor;
    if ([self.customView isKindOfClass:[UIImageView class]]) {
        UIImageView *customView = (UIImageView *)self.customView;
        customView.image = [customView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    if ([self.customView isKindOfClass:[UIActivityIndicatorView class]]) {
        UIActivityIndicatorView *customView = (UIActivityIndicatorView *)self.customView;
        customView.color = self.tintColor;
    }
}

#pragma mark - UIAppearance

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    [self setNeedsLayout];
}

- (void)setMinimumSize:(CGSize)minimumSize {
    _minimumSize = minimumSize;
    [self setNeedsLayout];
}

- (void)setCustomViewMarginBottom:(CGFloat)customViewMarginBottom {
    _customViewMarginBottom = customViewMarginBottom;
    [self setNeedsLayout];
}

- (void)setTextLabelMarginBottom:(CGFloat)textLabelMarginBottom {
    _textLabelMarginBottom = textLabelMarginBottom;
    [self setNeedsLayout];
}

- (void)setDetailTextLabelMarginBottom:(CGFloat)detailTextLabelMarginBottom {
    _detailTextLabelMarginBottom = detailTextLabelMarginBottom;
    [self setNeedsLayout];
}

- (void)setTextLabelAttributes:(NSDictionary *)textLabelAttributes {
    _textLabelAttributes = textLabelAttributes;
    if (self.textLabelText && self.textLabelText.length > 0) {
        // 刷新label的attributes
        self.textLabelText = self.textLabelText;
    }
}

- (void)setDetailTextLabelAttributes:(NSDictionary *)detailTextLabelAttributes {
    _detailTextLabelAttributes = detailTextLabelAttributes;
    if (self.detailTextLabelText && self.detailTextLabelText.length > 0) {
        // 刷新label的attributes
        self.detailTextLabelText = self.detailTextLabelText;
    }
}

@end


@interface ToastContentView (UIAppearance)

@end

@implementation ToastContentView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    ToastContentView *appearance = [ToastContentView appearance];
    appearance.insets = UIEdgeInsetsMake(16, 16, 16, 16);
    appearance.minimumSize = CGSizeZero;
    appearance.customViewMarginBottom = 8;
    appearance.textLabelMarginBottom = 4;
    appearance.detailTextLabelMarginBottom = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 22;
    paragraphStyle.maximumLineHeight = 22;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    appearance.textLabelAttributes = @{NSFontAttributeName: DefaultTextLabelFont, NSForegroundColorAttributeName: DefaultLabelColor, NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle1.minimumLineHeight = 18;
    paragraphStyle1.maximumLineHeight = 18;
    paragraphStyle1.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle1.alignment = NSTextAlignmentLeft;
    appearance.detailTextLabelAttributes = @{NSFontAttributeName: DefaultDetailTextLabelFont, NSForegroundColorAttributeName: DefaultLabelColor, NSParagraphStyleAttributeName: paragraphStyle1};
}


@end
