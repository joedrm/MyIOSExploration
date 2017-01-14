//
//  ViewController.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"IOS核心动画高级技巧(读书笔记)";
    self.titleArr = @[
                      @"2 寄宿图",
                      @"3 图层几何学",
                      @"4 视觉效果",
                      @"5 变换",
                      @"6.1 专有图层之 CAShapeLayer",
                      @"6.2 专有图层之 CATextLayer",
                      @"6.3 专有图层之 TransformLayer",
                      @"6.4 专有图层之 CAGradientLayer",
                      @"6.5 专有图层之 CAReplicatorLayer",
                      @"7 隐式动画",
                      @"8.1 显式动画之 CABasicAnimation",
                      @"8.2 显式动画之 CAKeyframeAnimation",
                      @"8.3 显式动画之 CAAnimationGroup",
                      @"8.3 过渡动画 CATransition",
                      @"9 图层时间",
                      @"10 缓冲"
                      ];
    
    
    self.vcArr = @[
                   
                   @"BoardViewLayerVC",
                   @"LayerGeometryVC",
                   @"VisualEffectVC",
                   @"TransformVC",
                   @"CAShapeLayerVC",
                   @"CATextLayerVC",
                   @"CATransformLayerVC",
                   @"CAGradientLayerVC",
                   @"CAReplicatorLayerVC",
                   @"ImplicitViewController",
                   @"CABasicAnimationVC",
                   @"CAKeyframeAnimationVC",
                   @"CAAnimationGroupVC",
                   @"CATransitionVC",
                   @"AnimationTimeVC",
                   @"CAMediaTimingFunctionVC"
                   ];
}


@end


/*
 http://bbs.520it.com/forum.php?mod=viewthread&tid=3060  离屏渲染原理，GPU 资源消耗原因和解决方案，ASDK 的基本原理
 https://github.com/nicklockwood/GLView    在IOS里面使用OpenGL创建3D模型，作者是Nick Lockwood：https://github.com/nicklockwood
 https://camo.githubusercontent.com/7b8b4f8740b5a4c9874c5a99d54f98855242f844/687474703a2f2f75706c6f61642d696d616765732e6a69616e7368752e696f2f75706c6f61645f696d616765732f313638373532312d633539636263306664373964313132392e706e673f696d6167654d6f6772322f6175746f2d6f7269656e742f7374726970253743696d61676556696577322f322f772f31323430  CoreAnimation 结构图
 */
























