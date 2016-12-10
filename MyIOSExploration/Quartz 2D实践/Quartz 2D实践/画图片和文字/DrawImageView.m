//
//  DrawImageView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "DrawImageView.h"

@implementation DrawImageView

// 画图片

- (void)drawRect:(CGRect)rect
{
    CGSize size = rect.size;
    
    UIImage* image = [UIImage imageNamed:@"apple.jpg"];
    
    // 绘制原始图片的大小
//    [image drawAtPoint:CGPointZero];
    
    // 裁剪
    UIRectClip(CGRectMake(10, 10, size.width*0.5, size.height*0.5));
    
    // 填充到指定的区域
    [image drawInRect:rect];
    
    // 平铺效果
//    [image drawAsPatternInRect:rect];
}

@end
