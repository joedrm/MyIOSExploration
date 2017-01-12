//
//  ImplicitViewController.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/1.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ImplicitViewController.h"

@interface ImplicitViewController ()
@property (nonatomic, strong) CALayer* colorLayer;
@end

@implementation ImplicitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    btn.centerX = self.view.centerX;
    btn.y = kScreenHeight - 30 - 20;
    [btn setTitle:@"START" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addActionHandler:^{
        [self changeColor];
    }];
    [self.view addSubview:btn];
}

- (void)test1{
    
    CALayer* colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(10, kStatusBarAndNavigationBarHeight+10, 100, 100);
    colorLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    self.colorLayer = colorLayer;
}


#pragma mark - CATransaction
/*
 Core Animation在每个run loop周期中自动开始一次新的事务（run loop是iOS负责收集用户输入，处理定时器或者网络事件并且重新绘制屏幕的东西），即使你不显式的用[CATransaction begin]开始一次事务，任何在一次run loop循环中属性的改变都会被集中起来，然后做一次0.25秒的动画
 
 直接对UIView关联的图层做动画而不是一个单独的图层，图层颜色瞬间切换到新的值，而不是之前平滑过渡的动画，Core Animation通常对CALayer的所有属性（可动画的属性）做动画，但是UIView把它关联的图层的这个特性关闭了
 
 UIKit是如何禁用隐式动画的：每个UIView对它关联的图层都扮演了一个委托，并且提供了-actionForLayer:forKey的实现方法。当不在一个动画块的实现中，UIView对所有图层行为返回nil，但是在动画block范围之内，它就返回了一个非空值。
 
 UIView关联的图层禁用了隐式动画，对这种图层做动画的唯一办法就是使用UIView的动画函数（而不是依赖CATransaction），或者继承UIView，并覆盖-actionForLayer:forKey:方法，或者直接创建一个显式动画（具体细节见第八章）。
 
 对于单独存在的图层，我们可以通过实现图层的-actionForLayer:forKey:委托方法，或者提供一个actions字典来控制隐式动画。
 */
- (void)changeColor{

//    [CATransaction begin];
//    [CATransaction setAnimationDuration:1.5];
//    [CATransaction setCompletionBlock:^{   // 完成块
//        CGAffineTransform transform = self.colorLayer.affineTransform;
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        self.colorLayer.affineTransform = transform;
//    }];
    self.colorLayer.backgroundColor = kRandomColor.CGColor;
//    [CATransaction commit];
}


#pragma mark - 实现自定义行为
- (void)test2{

    CALayer* colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(10, kStatusBarAndNavigationBarHeight+10, 100, 100);
    colorLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    [self.view.layer addSublayer:colorLayer];
    self.colorLayer = colorLayer;
}


#pragma mark - 呈现与模型
/*
 在iOS中，屏幕每秒钟重绘60次。如果动画时长比60分之一秒要长，Core Animation就需要在设置一次新值和新值生效之间，对屏幕上的图层进行重新组织。这意味着CALayer除了“真实”值（就是你设置的值）之外，必须要知道当前显示在屏幕上的属性值的记录。
 
 每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过-presentationLayer方法来访问。这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值，呈现树通过图层树中所有图层的呈现图层所形成。注意呈现图层仅仅当图层首次被提交（就是首次第一次在屏幕上显示）的时候创建
 
 在呈现图层上调用–modelLayer将会返回它正在呈现所依赖的CALayer。通常在一个图层上调用-modelLayer会返回–self（实际上我们已经创建的原始图层就是一种数据模型
 */

- (void)test3{

    CALayer* colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(10, kStatusBarAndNavigationBarHeight+10, 100, 100);
    colorLayer.position = self.view.center;
    colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    self.colorLayer = colorLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        self.colorLayer.backgroundColor = kRandomColor.CGColor;
    }else{
        [CATransaction begin];
        [CATransaction setDisableActions:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

@end
















