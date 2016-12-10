//
//  CurvingLine.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "CurvingLine.h"

@implementation CurvingLine

- (void)drawRect:(CGRect)rect{

    // 1. 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2. 绘制路径
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    
    // 3 把路径保存到上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    // 4 把内容渲染到View上
    CGContextStrokePath(ctx);
}

@end
