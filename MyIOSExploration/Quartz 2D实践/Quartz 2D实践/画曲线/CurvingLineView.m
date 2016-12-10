//
//  CurvingLine.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "CurvingLineView.h"

@implementation CurvingLineView


// 绘制曲线

- (void)drawRect:(CGRect)rect{

    CGSize size = rect.size;
    
    // 1. 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2. 描述路径
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(5, size.height*0.6)];
    // 2.2 添加曲线
    [path addQuadCurveToPoint:CGPointMake(size.width - 10, size.height*0.6)
                 controlPoint:CGPointMake(size.width*0.5, 10)];
    
    CGContextSetLineWidth(ctx, 5);
    
    [[UIColor blueColor] set];
    
    // 3 把路径保存到上下文中
    CGContextAddPath(ctx, path.CGPath);
    
    // 4 把内容渲染到View上
    CGContextStrokePath(ctx);
}

@end
