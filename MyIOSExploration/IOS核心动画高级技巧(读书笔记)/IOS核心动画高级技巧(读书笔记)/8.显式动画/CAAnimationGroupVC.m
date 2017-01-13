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
    
    [self.view addSubview:[self animationView]];
}

- (UIView *)animationView {
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, 30)];
    
    UIView  *shapeView1= [[UIView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    shapeView1.backgroundColor = UIColorGreen;
    shapeView1.layer.cornerRadius = 8;
    [animationView addSubview:shapeView1];
    
    UIView *shapeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    shapeView2.backgroundColor = UIColorRed;
    shapeView2.layer.cornerRadius = 8;
    [animationView addSubview:shapeView2];
    
    UIView *shapeView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    shapeView3.backgroundColor = UIColorBlue;
    shapeView3.layer.cornerRadius = 8;
    [animationView addSubview:shapeView3];
    
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.values = @[ @-5, @0, @10, @40, @70, @80, @75 ];
    positionAnimation.keyTimes = @[ @0, @(5 / 90.0), @(15 / 90.0), @(45 / 90.0), @(75 / 90.0), @(85 / 90.0), @1 ];
    positionAnimation.additive = YES;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.values = @[ @.7, @.9, @1, @.9, @.7 ];
    scaleAnimation.keyTimes = @[ @0, @(15 / 90.0), @(45 / 90.0), @(75 / 90.0), @1 ];
    
    CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.values = @[ @0, @1, @1, @1, @0 ];
    alphaAnimation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[positionAnimation, scaleAnimation, alphaAnimation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.repeatCount = HUGE_VALF;
    group.duration = 1.3;
    
    [shapeView1.layer addAnimation:group forKey:@"basic1"];
    group.timeOffset = .43;
    [shapeView2.layer addAnimation:group forKey:@"basic2"];
    group.timeOffset = .86;
    [shapeView3.layer addAnimation:group forKey:@"basic3"];
    
    return animationView;
}

- (void)shipAnimation{

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






