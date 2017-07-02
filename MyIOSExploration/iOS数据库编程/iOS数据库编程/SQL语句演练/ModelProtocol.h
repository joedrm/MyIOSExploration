//
//  ModelProtocol.h
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelProtocol <NSObject>

@required

/**
 操作模型必须实现的方法, 通过这个方法获取主键信息
 
 @return 主键字符串
 */
+ (NSString *)primaryKey;

@optional

/**
 忽略的字段数组
 
 @return 忽略的字段数组
 */
+ (NSArray *)ignoreColumnNames;


/**
 新字段名称-> 旧的字段名称的映射表格
 
 @return 映射表格
 */
+ (NSDictionary *)newNameToOldNameDic;

@end
