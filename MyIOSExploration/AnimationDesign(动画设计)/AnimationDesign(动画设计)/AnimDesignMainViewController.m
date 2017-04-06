//
//  AnimDesignMainViewController.m
//  AnimationDesign(动画设计)
//
//  Created by fang wang on 17/3/17.
//  Copyright © 2017年 animationDesign. All rights reserved.
//

#import "AnimDesignMainViewController.h"

@interface AnimDesignMainViewController ()

@end

@implementation AnimDesignMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"AnimationDesign(动画设计)";
    self.titleArr = @[
                      @"简单使用"
                      
                      ];
    
    
    self.vcArr = @[
                   @"SimpleUsedViewController"
                   ];
}


@end

/*
 本项目主要是学习动画的设计
 
 参考资料：
 
 https://github.com/airbnb/lottie-ios  近期比较牛逼的动画库，可以将 AE(Adobe After Effects) 生成的 Json 文件来做动画
 http://www.jianshu.com/p/d887c96684be  Airbnb开源炫酷动画库Lottie（译）
 
 https://github.com/Cloudox/Motion-Design-for-iOS  翻译自《Motion Design for iOS》，讲解iOS动画设计指南
 
 AE 资料
 https://helpx.adobe.com/cn/after-effects/after-effects-cs5-cs55-tutorials.html  
 http://www.howzhi.com/course/4556/
 
 */
