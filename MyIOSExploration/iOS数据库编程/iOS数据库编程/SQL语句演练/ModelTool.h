//
//  ModelTool.h
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelTool : NSObject


+ (NSString *)tableName:(Class)cls;


/**
 所有的有效成员变量, 以及成员变量对应的类型
 
 @param cls 类名
 @return 所有的有效成员变量, 以及成员变量对应的类型
 */
+ (NSDictionary *)classIvarNameTypeDict:(Class)cls;

/**
 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 
 @param cls 类名
 @return 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDict:(Class)cls;


+ (NSString *)columnNameAndTypesStr:(Class)cls;
@end
