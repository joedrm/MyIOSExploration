//
//  SQLiteTool.h
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteTool : NSObject


+ (BOOL) dealWithSql:(NSString *)sql uid:(NSString *)uid;



/**
 数据查询

 @param sql sql语句
 @param uid user id
 @return 返回结果
 */
+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid;
@end
