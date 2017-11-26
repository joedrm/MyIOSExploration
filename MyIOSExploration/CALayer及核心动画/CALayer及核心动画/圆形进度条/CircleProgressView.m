//
//  CircleProgressView.m
//  CALayer及核心动画
//
//  Created by wdy on 2017/11/26.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView()

@property (nonatomic, assign) CGFloat progress;
@end

@implementation CircleProgressView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(100, 100);  //设置圆心位置
    CGFloat radius = 90;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 5); //设置线条宽度
    CGContextSetLineCap(ctx, kCGLineCapRound);
    [[UIColor blueColor] setStroke]; //设置描边颜色
    
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx);  //渲染
}

- (void)drawProgress:(CGFloat )progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
