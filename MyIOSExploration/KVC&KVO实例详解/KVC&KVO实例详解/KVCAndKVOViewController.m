//
//  ViewController.m
//  KVC&KVO实例详解
//
//  Created by fang wang on 16/12/21.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "KVCAndKVOViewController.h"

@interface KVCAndKVOViewController ()

@end

@implementation KVCAndKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVC&KVO实例详解";
    self.titleArr = @[
                      @"KVO监听数组",
                      @"手动触发KVO",
                      @"KVOController的使用"
                      ];
    
    self.vcArr = @[
                   @"KVOObserveArrayVC",
                   @"SetKVOViewController",
                   @"TestKVOController"
                   ];
}


@end

/*
 https://github.com/huang303513/iOSKeyPointExploration/tree/master/%E6%89%8B%E5%8A%A8%E5%AE%9E%E7%8E%B0KVO%E3%80%81%E6%B3%A8%E5%86%8C%E4%BE%9D%E8%B5%96%E9%94%AE%E3%80%81%E9%9B%86%E5%90%88%E5%B1%9E%E6%80%A7%E7%9B%91%E5%90%AC
 
 http://www.jianshu.com/p/70b2503d5fd1   一句代码，更加优雅的调用KVO和通知
 https://objccn.io/issue-7-3/    KVC 和 KVO
 http://zyden.vicp.cc/kvc-kvo-advanced/  KVC KVO高阶应用
 http://ppsheep.com/all-tags/KVC%E5%92%8CKVO/   KVC与KVO三篇
 http://www.imlifengfeng.com/blog/?p=493  KVC详解
 http://www.imlifengfeng.com/blog/?p=498  KVO详解
 
 https://gold.xitu.io/post/58be0b40128fe1006451f586 如何优雅地使用 KVO
 
 https://github.com/JustKeepRunning/LXD_KeyValueObserveDemo  
 
 http://www.iosxxx.com/blog/2017-03-27-iOS%E7%9A%84nstimer%E4%B8%8Ekvo%E7%9A%84%E8%87%AA%E9%87%8A%E6%94%BE.html iOS的NSTimer与KVO的自释放
 */
