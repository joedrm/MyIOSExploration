//
//  CAKeyframeAnimationVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/7.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CAKeyframeAnimationVC.h"

@interface CAKeyframeAnimationVC ()
@property (nonatomic, strong) CALayer *testLayer;
@end

@implementation CAKeyframeAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer* testLayer = [CALayer layer];
    testLayer.frame = CGRectMake(0, 0, 100, 100);
    testLayer.position = self.view.center;
    testLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:testLayer];
    self.testLayer = testLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self rotate2];
}

// CAKeyframeAnimation同样是CAPropertyAnimation的一个子类，它依然作用于单一的一个属性，和CABasicAnimation不一样的是，它不限制于设置一个起始和结束的值，而是可以根据一连串随意的值来做动画。
- (void)demo1{

    CAKeyframeAnimation* keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.duration = 2.0;
    keyAnimation.keyPath = @"backgroundColor";
    keyAnimation.values = @[(__bridge id)[UIColor redColor].CGColor,
                            (__bridge id)[UIColor blueColor].CGColor,
                            (__bridge id)[UIColor orangeColor].CGColor];
    [self.testLayer addAnimation:keyAnimation forKey:nil];
}


// CGPath去指定动画
- (void)demo2{
    
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
    anim.duration = 4.0;
    anim.keyPath = @"position";
    anim.rotationMode = kCAAnimationRotateAuto; // 图层将会根据曲线的切线自动旋转方向
    [shipLayer addAnimation:anim forKey:nil];
}

#pragma mark - 虚拟属性
// 考虑一个旋转的动画：如果想要对一个物体做旋转的动画，那就需要作用于transform属性，因为CALayer没有显式提供角度或者方向之类的属性
- (void)rotate{
    
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"transform";
    anim.duration = 2.0;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0, 1)]; // 完全没变化
    [self.testLayer addAnimation:anim forKey:nil];
}

// 上面的旋转看似没什么问题，但是如果把旋转的值从M_PI（180度）调整到2 * M_PI（360度），完全没变化。因为这里的矩阵做了一次360度的旋转，和做了0度是一样的，所以最后的值根本没变。
// 为了旋转图层，我们可以对transform.rotation关键路径应用动画，而不是transform本身
// transform.rotation实际上是一个CALayer用于处理动画变换的虚拟属性
- (void)rotate2{
    
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.duration = 2.0;
    anim.byValue = @(M_PI*2);
    [self.testLayer addAnimation:anim forKey:nil];
}

@end









