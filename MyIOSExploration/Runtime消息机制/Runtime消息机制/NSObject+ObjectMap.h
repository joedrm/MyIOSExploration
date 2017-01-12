//
//  NSObject+ObjectMap.h
//  Runtime消息机制
//
//  Created by wangdongyang on 16/9/8.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelDelegate <NSObject>

@optional
// 提供一个协议，只要准备这个协议的类，都能把数组中的字典转模型

+ (NSDictionary *)arrayContainModelClass;

@end


@interface NSObject (ObjectMap)

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
