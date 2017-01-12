//
//  ContextStackView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ContextStackView.h"

@implementation ContextStackView


- (void)drawRect:(CGRect)rect{

    CGSize size = rect.size;
    CGFloat padding = 20;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(padding, size.height*0.5)];
    [path addLineToPoint:CGPointMake(size.width - padding*2, size.height*0.5)];
    
    CGContextAddPath(ctx, path.CGPath);
    // 这里保存的是系统的上下文状态
    CGContextSaveGState(ctx);
    
    // 设置上下文状态
    CGContextSetLineWidth(ctx, 10.0f);
    [[UIColor redColor] set];
    
    // 保存当前上下文状态（上面设置的状态）
//    CGContextSaveGState(ctx);
    
    CGContextStrokePath(ctx);
    
    
    // 添加第二条线
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(size.height*0.5, padding)];
    [path2 addLineToPoint:CGPointMake(size.height*0.5, size.width - padding*2)];
    
    CGContextAddPath(ctx, path2.CGPath);
    
    // 从上下文状态栈中恢复上下文的状态
    CGContextRestoreGState(ctx);
    
    CGContextStrokePath(ctx);
}

@end
