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
 
 http://www.jianshu.com/p/4f0ce4380dda  iOS中的锁
 
 https://github.com/Tinghui/HUIGCDDispatchAsync  GCD取消的Demo
 
 https://www.zhihu.com/question/33515481  并发与并行的区别？
 
 https://github.com/upworldcjw/test/tree/master/TestGCDQueue/TestGCDQueue  测试dispatch_sync在并行queue如何并发的Demo 
 https://github.com/upworldcjw/wiki/wiki/%E5%B9%B6%E8%A1%8C%E9%98%9F%E5%88%97-%E7%BA%BF%E7%A8%8B%E5%AE%89%E5%85%A8
 
 http://www.cocoachina.com/industry/20140428/8248.html  GCD 深入理解（一）
 
 http://www.jianshu.com/p/938d68ed832c  iOS中保证线程安全的几种方式与性能对比
 
 // GCD封装
 http://www.jianshu.com/p/0630c903e1db
 https://github.com/JustKeepRunning/LXDDispatchOperation

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









