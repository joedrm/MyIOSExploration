//
//  ViewController.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"导航条的处理";
    
    self.titleArr = @[@"禁用交互式返回",
                      @"隐藏导航栏",
                      @"ScrollView上的交互式返回",
                      @"移除中间控制器",
                      @"自定义NavigationBar",
                      @"转场动画"];
    
    self.vcArr = @[@"DisableInteractivePopVC",
                   @"HideNavigationBarVC",
                   @"ScrollBackViewController",
                   @"PushRemoveViewController",
                   @"CustomNavigationBarVC",
                   @"TransitionViewController"
                   ];
}

/*
 参考资料：
 https://github.com/rickytan/RTRootNavigationController
 
 */


@end
