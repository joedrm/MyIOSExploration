//
//  SingleTool.m
//  GCD实践
//
//  Created by wangdongyang on 16/9/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "SingleTool.h"

@interface SingleTool ()<NSCopying, NSMutableCopying>

@end

@implementation SingleTool

static SingleTool* _instance;

// 弊端：多个个线程访问会出现安全问题
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    if (_instance == nil) {
//        _instance = [super allocWithZone:zone];
//    }
//    return _instance;
//}


/*
 1、提供一个static修饰全局的静态变量：static SingleTool* _instance;
 2、重写allocWithZone:方法，采用GCD中的dispatch_once_t创建一个线程安全的实例
 3、提供一个类方法，方便外界来访问
 4、重写 copyWithZone:(NSZone *)zone 和 mutableCopyWithZone:(NSZone *)zone方法
 */
// GCD来实现
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 本身线程就是安全的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareInstance
{
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


// ------ MRC环境下
// 重写 release retain 和  retainCount方法
/*
- (oneway void)release
{
    return _instance;
}

- (oneway void)retain
{
    return _instance;
}

- (oneway void)retainCount
{
    return _instance;
}
 */
@end






