//
//  SQLiteModelTool.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import "SQLiteModelTool.h"
#import "SQLiteTool.h"
#import "ModelTool.h"

@implementation SQLiteModelTool

+ (BOOL)createTable:(Class)class uid:(NSString *)uid
{
    // 1. 创建表格
    
    // 1.1 获取表名
    NSString* tableName = [ModelTool tableName:class];
    
    if (![class respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    
    NSString* pramaryKey = [class primaryKey];
    
    
    // 1.2 获取一个模型里面所有的字段, 以及类型
    NSString* createTableSQL = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [ModelTool columnNameAndTypesStr:class], pramaryKey];
    
    // 2. 执行sql语句
    return [SQLiteTool dealWithSql:createTableSQL uid:uid];
}

+ (void)saveModel:(id)model{

    
}

@end






















