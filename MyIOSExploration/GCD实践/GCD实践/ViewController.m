//
//  ViewController.m
//  GCD实践
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 https://github.com/YouXianMing/GCD-Program GCD的封装
 https://github.com/ibireme/YYKit   很多关于异步绘制、线程安全的实践，需要反复阅读
    https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYTimer.h   dispatch_source_t和dispatch_semaphore_t实现的定时器
    https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYThreadSafeArray.h  线程安全的数组
    https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYAsyncLayer.h  layer的异步绘制
    http://dreamerpanda.cn/2016/07/18/YYCache-analyzing/
 
 
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"GCD实践";
    self.titleArr = @[@"GCD Basic 基础知识",
                      @"Singleton Pattern 单例模式的实现",
                      @"GCD lock 锁",
                      @"Dispatch source 分派源",
                      @"Dispatch semaphore 信号量",
                      @"更精准的定时器"];
    
    self.vcArr = @[@"GCDBasicVC",
                   @"SingleViewController",
                   @"LockViewController",
                   @"DispatchSourceVC",
                   @"DispatchSemaphoreVC",
                   @"GDCTimerVC"
                   ];
}




@end









