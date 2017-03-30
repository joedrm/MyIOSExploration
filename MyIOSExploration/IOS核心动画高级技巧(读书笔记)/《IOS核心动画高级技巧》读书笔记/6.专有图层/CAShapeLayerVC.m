//
//  ProperLayerViewController.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 wdy. All rights reserved.
//



#import "CAShapeLayerVC.h"


@interface CAShapeLayerVC ()

@end

@implementation CAShapeLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testShapeLayer];
    [self test2];
}

#pragma mark - 1.CAShapeLayer
// CAShapeLayer 与 使用Core Graphics直接向原始的CALyer绘制 的区别：
/*
 渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
 高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
 不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 */
- (void)testShapeLayer{

    UIBezierPath* path = [UIBezierPath bezierPath];
    // 画圆
    [path addArcWithCenter:CGPointMake(175, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [path moveToPoint:CGPointMake(175, 125)];
    [path addLineToPoint:CGPointMake(175, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    
    [path moveToPoint:CGPointMake(175, 175)];
    [path addLineToPoint:CGPointMake(225, 225)];
    
    [path moveToPoint:CGPointMake(125, 150)];
    [path addLineToPoint:CGPointMake(225, 150)];
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
}


#pragma mark - 2.圆角
- (void)test2{
    CGFloat wh = 200;
    CGRect rect = CGRectMake((self.view.width - wh)*0.5, (self.view.height - wh)*0.5+100, wh, wh);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner coner = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:coner cornerRadii:radii];
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
}



@end
























