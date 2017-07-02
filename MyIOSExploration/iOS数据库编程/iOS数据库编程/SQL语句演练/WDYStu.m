//
//  WDYStu.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import "WDYStu.h"

@implementation WDYStu

+ (NSString *)primaryKey{
    return @"stuNum";
}

// 忽略字段
+ (NSArray *)ignoreColumnNames{

    return @[@"address"];
}
@end
