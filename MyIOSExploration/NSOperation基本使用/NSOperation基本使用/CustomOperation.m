//
//  CustomOperation.m
//  NSOperation基本使用
//
//  Created by wangdongyang on 16/9/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

// 重写mian方法，告知要执行什么任务

- (void)main
{
    NSLog(@"%@", [NSThread currentThread]);
    
    for (int i = 0; i < 10000; i ++) {
        NSLog(@"%@", [NSThread currentThread]);
    }
    
    if (self.isCancelled) { // 取消
        return;
    }
    
    for (int i = 0; i < 10000; i ++) {
        NSLog(@"%@", [NSThread currentThread]);
    }
    
    if (self.isCancelled) {// 取消
        return;
    }
    
    for (int i = 0; i < 10000; i ++) {
        NSLog(@"%@", [NSThread currentThread]);
    }
    
    if (self.isCancelled) {// 取消
        return;
    }
}

@end
