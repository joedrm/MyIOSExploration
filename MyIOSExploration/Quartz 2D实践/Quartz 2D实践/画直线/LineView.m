//
//  LineView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "LineView.h"

@implementation LineView


- (void)drawRect:(CGRect)rect{

    CGSize size = rect.size;
    
    // 1. 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2. 绘制路径
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    // 2.1 设置起点
    [path moveToPoint:CGPointMake(10, 10)];
    // 2.2 设置终点
    [path addLineToPoint:CGPointMake(size.width - 10, size.height * 0.5)];
    
    // 2.3 画第二条线
//    [path moveToPoint:CGPointMake(50, 100)];
    [path addLineToPoint:CGPointMake(20, size.height - 30)];
    
    // 上下文的状态
    // 设置线宽
    CGContextSetLineWidth(ctx, 10);
    // 设置线的连接样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    // 设置线的顶角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    // 设置线的颜色
    [[UIColor redColor] set];
    
    // 3 把路径保存到上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    // 4 把内容渲染到View上
    CGContextStrokePath(ctx);
}

@end








