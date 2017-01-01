//
//  LayerLabel.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/1.
//  Copyright © 2017年 wdy. All rights reserved.
//


// UILabel的替代品

#import "LayerLabel.h"

@interface LayerLabel ()
@end

@implementation LayerLabel

+ (Class)layerClass{

    return [CATextLayer class];
}

- (CATextLayer*)textLayer{
    
    return (CATextLayer*)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{

    self.text = self.text;
    self.textColor = self.textColor;
    self.font = self.font;
    
    [self textLayer].alignmentMode = kCAAlignmentJustified;
    [self textLayer].wrapped = YES;
    [self.layer display];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    [self setup];
}

- (void)setText:(NSString *)text{

    super.text = text;
    [self textLayer].string = text;
}

- (void)setTextColor:(UIColor *)textColor{
    
    super.textColor = textColor;
    [self textLayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font{
    
    super.font = font;
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    [self textLayer].font = fontRef;
    [self textLayer].fontSize = font.pointSize;
    
    CGFontRelease(fontRef);
}
@end














