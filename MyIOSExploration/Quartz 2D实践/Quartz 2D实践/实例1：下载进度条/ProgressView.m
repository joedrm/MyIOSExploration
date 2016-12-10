//
//  ProgressView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // 画弧
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center =  CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    CGFloat radius = rect.size.width*0.5 - 10;
    CGFloat startA = -M_PI_2;
    CGFloat angle = self.progress * M_PI * 2;
    CGFloat endA = angle + startA;
    
    // 描述路径
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    // 设置属性
    [[UIColor redColor] set];
    CGContextSetLineWidth(ctx, 5.0f);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // 把路径添加上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    // 把上下文内容渲染到view上
    CGContextStrokePath(ctx);
}


@end
