//
//  ViewController.m
//  UIView动画详解
//
//  Created by fang wang on 17/2/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AnimateMianViewController.h"

@interface AnimateMianViewController ()

@end

@implementation AnimateMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UIView动画";
    self.titleArr = @[@"Position动画",
                      @"Opacity动画",
                      @"Scale动画",
                      @"Color动画",
                      @"Rotation动画",
                      @"Repeat重复动画",
                      @"Easing动画"
                      ];
    
    self.vcArr = @[@"PositionAnimViewController",
                   @"OpacityAnimViewController",
                   @"ScaleAnimViewController",
                   @"ColorAnimViewController",
                   @"RotationAnimViewController",
                   @"RepeatAnimViewController",
                   @"EasingAnimViewController"
                   ];
}


@end

/*
 https://github.com/daltoniam/DCAnimationKit  
 https://github.com/minggo620/iOSViewAnimation
 https://github.com/Cloudox/Motion-Design-for-iOS  翻译自《Motion Design for iOS》，讲解iOS动画设计指南
 */
