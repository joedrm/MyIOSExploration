//
//  RectangleView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "RectangleView.h"

@implementation RectangleView

// 画矩形

- (void)drawRect:(CGRect)rect{
    
    CGSize size = rect.size;
    
    // 1. 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2. 描述路径, 矩形路径
//    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 100, 200, 50)];
    // 圆角矩形
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, size.height*0.4, size.width - 20, 50) cornerRadius:10];
    
    [[UIColor blueColor] set];
    
    // 3 把路径保存到上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    // 4 把内容渲染到View上
    CGContextFillPath(ctx);
    
}

@end
