//
//  Student.m
//  Runtime消息机制
//
//  Created by wangdongyang on 16/9/8.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "Student.h"
#import <objc/message.h>

@interface Student ()

@end

@implementation Student

// 没有返回值,也没有参数
// void,(id,SEL)
void goToSchool(id self, SEL _cmd, NSNumber *meter) {
    
    NSLog(@"上学：%@", meter);
    
}

// 任何方法默认都有两个隐式参数,self,_cmd
// 什么时候调用:只要一个对象调用了一个未实现的方法就会调用这个方法,进行处理
// 作用:动态添加方法,处理未实现
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == NSSelectorFromString(@"goToSchool:")) {
        
        // class: 给哪个类添加方法
        // SEL: 添加哪个方法
        // IMP: 方法实现 => 函数 => 函数入口 => 函数名
        // type: 方法类型
        class_addMethod(self, sel, (IMP)goToSchool, "v@:@");
        
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


- (void)learn
{
    NSLog(@"学生学习");
}


+ (void)exam
{
    NSLog(@"学生考试");
}
@end
