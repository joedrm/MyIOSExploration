//
//  ModelTool.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import "ModelTool.h"
#import "ModelProtocol.h"
#import <objc/runtime.h>

@implementation ModelTool


+ (NSString *)tableName:(Class)cls{
    
    return NSStringFromClass(cls);
}

+ (NSDictionary *)classIvarNameTypeDict:(Class)cls{

    unsigned int outCount = 0;
    Ivar *ivarList =  class_copyIvarList(cls, &outCount);
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    NSArray* ignoreNames = nil;
    if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
        ignoreNames = [cls ignoreColumnNames];
    }
    
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivarList[i];
        
        // 1. 获取成员变量名称
        NSString *ivarName = [NSString stringWithUTF8String: ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        if([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        // 2. 获取成员变量类型
        NSString* type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [dict setObject:type forKey:ivarName];
    }
    return dict;
}

/* 测试打印的结果
 dict = {
     "_age" = i;
     "_name" = "@\"NSString\"";
     "_score" = f;
     "_stuNum" = i;
 }
 */



+ (NSDictionary *)classIvarNameSqliteTypeDict:(Class)cls{

    NSMutableDictionary* dict = [[self classIvarNameTypeDict:cls] mutableCopy];
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL * _Nonnull stop) {
        dict[key] = typeDic[obj];
    }];
    return dict;
}


+ (NSString *)columnNameAndTypesStr:(Class)cls{

    NSMutableArray* result = [NSMutableArray array];
    NSDictionary* nameTypeDic = [self classIvarNameSqliteTypeDict:cls];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    return [result componentsJoinedByString:@","];
}

#pragma mark - 私有的方法
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}

@end






