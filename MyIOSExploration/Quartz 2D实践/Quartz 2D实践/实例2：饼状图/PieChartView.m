//
//  PieChartView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

- (void)drawRect:(CGRect)rect{
    
    [self fun2];
}

// 抽取后
- (void)fun2{

    NSArray* arr = @[@30, @60, @10];
    NSArray* corlorArr = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    
    CGSize size = self.bounds.size;
    CGPoint center =  CGPointMake(size.width * 0.5, size.height * 0.5);
    CGFloat radius = size.width * 0.5 - 10;
    CGFloat startA = 0; // 开始角度
    CGFloat angle = 0; // 弧度
    CGFloat endA = 0; //结束角度
    for (int i = 0; i< arr.count; i++) {
        
        NSNumber* value = arr[i];
        UIColor* color = corlorArr[i];
        
        startA = endA; // 开始角度
        angle = value.intValue / 100.0 * M_PI * 2; // 弧度
        endA = angle + startA; //结束角度
        UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        [color set];
        [path addLineToPoint:center];
        [path fill];
    }
}

- (void)fun1{
    // 1. 先第一个画扇形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize size = self.bounds.size;
    CGPoint center =  CGPointMake(size.width*0.5, size.height*0.5);
    CGFloat radius = size.width*0.5 - 10;
    CGFloat startA = 0; // 开始角度
    CGFloat angle = 25 / 100.0 * M_PI_2 * 2; // 弧度
    CGFloat endA = angle + startA; //结束角度
    // 描述路径
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    // 设置属性
    [[UIColor redColor] set];
    // 把路径添加上下文中
    CGContextAddPath(ctx, path.CGPath);
    // 把上下文内容渲染到view上
    CGContextFillPath(ctx);
    
    
    // 2. 第二个画扇形
    startA = endA; // 开始角度
    angle = 25 / 100.0 * M_PI_2 * 2; // 弧度
    endA = angle + startA; //结束角度
    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    [[UIColor blueColor] set];
    [path fill];
    
    
    // 3. 第三个画扇形
    startA = endA; // 开始角度
    angle = 50 / 100.0 * M_PI_2 * 2; // 弧度
    endA = angle + startA; //结束角度
    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    [[UIColor blueColor] set];
    [path fill];
}

@end













