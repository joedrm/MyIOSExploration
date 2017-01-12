//
//  RadianView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "RadianView.h"

@implementation RadianView


- (void)drawRect:(CGRect)rect
{
    /*
     * Center: 弧所在的圆心
     * radius: 弧的半径
     * startAngle: 开始角度
     * endAngle: 结束角度
     * clockwise: Yes:顺时针 No:逆时针
     */
    CGPoint center =  CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    
    CGFloat radius = rect.size.width*0.5 - 10;
    
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    // 画扇形
    [path addLineToPoint:center];
    
    // 关闭路径
    [path closePath];
    
    [[UIColor greenColor] set];
    
    [path fill];
}

@end
