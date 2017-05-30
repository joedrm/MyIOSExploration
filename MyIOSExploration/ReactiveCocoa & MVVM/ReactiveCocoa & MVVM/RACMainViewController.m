//
//  RACMainViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "RACMainViewController.h"

@interface RACMainViewController ()

@end

@implementation RACMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ReactiveCocoa & MVVM";
    self.titleArr = @[
                      @"RAC常用类和基本使用",
                      @"RAC开发中常见用法",
                      @"RAC中常见的宏",
                      @"RAC常见信号操作方法",
                      @"组合信号实例一：combine",
                      @"MVVM实战：登录界面"
                      ];
    
    self.vcArr = @[
                   @"BasicSimpleViewController",
                   @"CommonApplyViewController",
                   @"RACMacrosViewController",
                   @"SignalOperateViewController",
                   @"CombineViewController",
                   @"RACLoginViewController"
                   ];
}


@end



/*
 参考资料：
 https://github.com/shenAlexy/MVVM  MVVM架构的一次实践，重写iOS头条客户端
 
 https://github.com/wangtongke/WTKMVVMRAC   高仿电商项目，采用MVVM+ReactiveCocoa
 
 http://www.starming.com/index.php?v=index&view=101 iOS函数响应式编程以及ReactiveCocoa的使用
 
 https://github.com/leichunfeng/MVVMReactiveCocoa  GitBucket iOS App
 
 https://github.com/BinBear/breadtrip-ReactiveCocoa-MVVM-  仿面包旅行，ReactiveCocoa+MVVM
 
 http://www.jianshu.com/p/f068f5783d82   iOS RAC的使用总结
 
 http://www.jianshu.com/p/3beb21d5def2   iOS MVVM+RAC 从框架到实战
 
 http://www.jianshu.com/p/01546347bad5   iOS函数响应式编程以及ReactiveCocoa的使用
 
 https://github.com/arduomeng/OCDemo_me/tree/bc22cc5636e78e2cf34a2a8ebba7c5962a4f41bb/RAC
 
 https://github.com/ReactiveCocoa/ReactiveObjC  The 2.x ReactiveCocoa Objective-C API: Streams of values over time
 
 https://github.com/Josin22/JSShopCartModule MVVM实例，购物车通用模板
 
 https://github.com/ValiantCat/FRPCheatSheeta  函数式编程框架：ReactiveCocoa,RXSwift速查表
 
 https://github.com/wujunyang/MVVMReactiveCocoaDemo  ReactiveCocoa的知识点及MVVM模式运用（不断更新中....）
 
 https://github.com/Jerry4me/JRReactiveCocoa  RAC基本用法及MVVM的小demo
 
 MVVM
 https://github.com/coderyi/MVVMDemo
 
 https://github.com/lizelu/MVVM
 */
