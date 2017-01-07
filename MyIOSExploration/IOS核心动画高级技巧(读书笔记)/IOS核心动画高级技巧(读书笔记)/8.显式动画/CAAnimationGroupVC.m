//
//  CAAnimationGroupVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/7.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CAAnimationGroupVC.h"

@interface CAAnimationGroupVC ()

@end

@implementation CAAnimationGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 250)];
    [path addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(235, 300)];
    
    CAShapeLayer* pathLayer = [CAShapeLayer layer];
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.lineWidth = 4.0;
    [self.view.layer addSublayer:pathLayer];
    
    CALayer* shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 30, 30);
    shipLayer.backgroundColor = [UIColor blueColor].CGColor;
    shipLayer.position = CGPointMake(0, 150);
    [self.view.layer addSublayer:shipLayer];
    
    CAKeyframeAnimation* anim = [CAKeyframeAnimation animation];
    anim.path = path.CGPath;
    anim.keyPath = @"position";
    anim.rotationMode = kCAAnimationRotateAuto; // 图层将会根据曲线的切线自动旋转方向
    
    CABasicAnimation* basicAnim = [CABasicAnimation animation];
    basicAnim.keyPath = @"backgroundColor";
    basicAnim.toValue = (__bridge id _Nullable)([UIColor redColor].CGColor);
    
    // 动画
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.duration = 4.0;
    group.animations = @[anim, basicAnim];
    group.fillMode = kCAFillModeForwards;
    [shipLayer addAnimation:group forKey:nil];
}


@end






