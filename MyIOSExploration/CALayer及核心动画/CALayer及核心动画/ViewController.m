//
//  ViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

/*
 参考资料：
 
 学习步骤
 1. https://github.com/AttackOnDobby/iOS-Core-Animation-Advanced-Techniques  在读
    demo:https://github.com/huang303513/HCDCoreAnimation
 
 2. https://github.com/KittenYang/A-GUIDE-TO-iOS-ANIMATION
 
 3. https://github.com/YouXianMing/Animations   
    https://github.com/YouXianMing/YoCelsius
    https://github.com/YouXianMing/UI-Component-Collection
 
 4. https://github.com/MartinRGB/LearnCube-iOS
 
 5. https://github.com/intuit/AnimationEngine
 
 http://www.jianshu.com/p/78c30ccf425f  CATransform3D笔记 https://github.com/HApple/CATransform3D
 
 
 https://github.com/minggo620/iOSViewAnimation  主要是UIView动画
 
 
 awesome
 https://github.com/ameizi/awesome-ios-animation
 http://www.jianshu.com/p/9fed46a83ad9
 https://github.com/CRAnimation/CRAnimation  CRAnimation Pod仓库中整理了各种封装好的动效代码
 
 Swift 知名动画框架
 https://github.com/lkzhao/Hero
 https://github.com/MengTo/Spring
 
 
IOS动画总结:
 https://github.com/xiaochaofeiyu/YSCAnimation
 https://github.com/yixiangboy/IOSAnimationDemo
 https://github.com/wangtongke/WTKTransitionAnimate
 https://github.com/wangtongke/WTKTransitionAnimation
 https://github.com/weng1250/WZLBadge
 https://github.com/a130785/iosAnimationDemo
 https://github.com/shu223/AnimatedTransitionGallery
 https://github.com/jhurray/JHChainableAnimations
 https://github.com/adad184/MMTweenAnimation
 https://github.com/Raizlabs/RZTransitions
 https://github.com/bryanoltman/CAAnimation-EasingEquations
 https://github.com/GirlCunt/AnimationDemo
 https://github.com/tapharmonic/Core-Animation-Demos  ***
 https://github.com/AugustRush/ARAnimation  ARAnimation is an Core Animation library to make you animations easily.
 // 丰富的路径动画，可以自己定制设计动画路径
 https://github.com/airbnb/lottie-ios   http://jeremie-martinez.com//2016/09/15/train-animations/
 
 http://www.jianshu.com/p/9b3a3b4006ef  iOS动画详解(学习动画看这一篇就够了)
 
 https://github.com/warrenm/AHEasing  很不错动画函数库
 
 
 动画实例：
 https://github.com/shu223/PulsingHalo  雷达效果
 https://github.com/daltoniam/DCAnimationKit  一系列的动画练习
 https://github.com/robb/RBBAnimation  同上
 https://github.com/jhurray/JHChainableAnimations 同上
 https://github.com/IFTTT/JazzHands
 https://github.com/xinge1/LXWaveProgress  水波纹动画 
 https://github.com/xinge1/LXAnimationDemo  iOS动画实现Demo（波纹，缩放，弹性，平移等）
 http://www.jianshu.com/p/6b4347bd6c6f  YQDownloadButton---带有波浪效果和震动波效果的动画
 https://github.com/iosyaowei/exampleForAnimation  iOS动画合集-动画基础到常用的动画案例
 https://github.com/Josin22/JSDownloadView  精巧顺滑的下载动画实现和思路讲解
 https://github.com/Josin22/JSWave  波浪动画
 https://github.com/631106979/WCLShineButton  
 http://www.jianshu.com/c/dbf97f100a39  与瓜一起学iOS动画，很多不错的动画示例
 https://github.com/mengxianliang/XLCircleProgress  圆环进度指示器
 https://github.com/mengxianliang/XLDotLoading  新浪微博的红包加载动画
 
 Facebook-POP
 
 intro
 http://www.cocoachina.com/industry/20140704/9034.html
 http://www.cocoachina.com/design/20140210/7791.html
 http://www.cocoachina.com/industry/20140527/8565.html
 github
 https://github.com/facebook/pop
 https://github.com/schneiderandre/popping
 https://github.com/hossamghareeb/Facebook-POP-Tutorial
 https://github.com/ColinEberhardt/VCTransitionsLibrary
 
 
 转场动画
 http://www.jianshu.com/p/45434f73019e  iOS自定义转场动画
 https://github.com/wazrx/XWTransition  几句代码快速集成自定义转场效果+ 全手势驱动
 https://github.com/Raizlabs/RZTransitions 自定义转场
 https://github.com/ColinEberhardt/VCTransitionsLibrary
 https://github.com/recruit-mp/RMPZoomTransitionAnimator
 https://github.com/AugustRush/ARTransitionAnimator
 https://github.com/mh4u/XXTransition/  应付各种需求的转场动画
 https://github.com/bawn/LCSpreadTransition  豌豆荚一览的页面切换效果
 
 
 动画设计
 http://charsdavy.github.io/2016/07/31/design-complex-animation-effect/  设计复杂的iOS动画效果
 http://www.jianshu.com/p/3fe831108001 iOS app旧貌换新颜(一)—Launch Page让Logo"飞"出屏幕
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CALayer及核心动画";
    self.titleArr = @[@"CATransform3D",
                      @"自定义Layer",
                      @"时钟动画",
                      @"CABasicAnimation(基础核心动画)",
                      @"心跳效果",
                      @"CAKeyframeAnimation(图片抖动)",
                      @"CATransition转场动画",
                      @"CAAnimationGroup(动画组)",
                      @"转盘动画",
                      @"图片折叠",
                      @"播放器音量震动条",
                      @"粒子效果",
                      @"仿QQ粘性布局",
                      @"CAShapeLayer各种实例"];
    
    self.vcArr = @[@"CATransformVC",
                   @"CustomLayerVC",
                   @"ClockViewController",
                   @"CABasicAnimationVC",
                   @"HeartBeatEffectVC",
                   @"CAKeyframeAnimationVC",
                   @"CATransitionDemoVC",
                   @"CAAnimationGroupVC",
                   @"MyWheelViewController",
                   @"ImageFoldViewController",
                   @"VoiceShakeViewController",
                   @"ParticleEffectViewController",
                   @"QQViewController",
                   @"CAShapeLayerViewController"
                   ];
}


@end

