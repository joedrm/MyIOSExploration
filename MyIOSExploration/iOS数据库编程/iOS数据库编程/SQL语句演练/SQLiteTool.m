//
//  SQLiteTool.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import "SQLiteTool.h"
#import "sqlite3.h"

//#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

#define kCachePath @"/Users/wdy/Desktop"

@implementation SQLiteTool

sqlite3 *ppDb = nil;

+ (BOOL)dealWithSql:(NSString *)sql uid:(NSString *)uid{

    if (![self openDB:uid]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    // 执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    return result;
}


+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid{

    [self openDB:uid];
    // 准备语句（预处理语句）
    
    // 1. 创建准备语句

    /*
     参数一：一个已经打开的数据库
     参数二：需要执行的sql语句
     参数三：参数二取出多少字节的长度，-1 表示自动计算
     参数四：准备语句
     参数五：通过参数三，取出参数二的长度字节后，剩下的字符串
     */
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备失败！");
        return nil;
    };
    
    // 2. 绑定数据
    
    // 3. 执行sql语句
    NSMutableArray* rowDictArr = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 -》 字典
        // 1. 获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        NSMutableDictionary* rowDict = [NSMutableDictionary dictionary];
        
        [rowDictArr addObject:rowDict];
        
        // 2. 遍历所有的列
        for (int i = 0; i < columnCount; i ++) {
            // 2.1 获取列名
            const char * columnNameC = sqlite3_column_name(ppStmt, i);
            NSString* columnName = [NSString stringWithUTF8String:columnNameC];
            // 2.2 获取列值
            
            // 2.2.1 获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            
            /* 列的类型：
                 #define SQLITE_INTEGER
                 #define SQLITE_FLOAT
                 #define SQLITE_BLOB
                 #define SQLITE_NULL
                 #define SQLITE3_TEXT
             */
            // 2.2.2 根据列的类型，使用不同的函数，获取列值
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(ppStmt, i)];
                    break;
                default:
                    break;
            }
            
            [rowDict setValue:value forKey:columnName];
        }
        
        // 3. 获取列名和列值
    };
    
    // 4. 重置（可以省略）
    
    // 5. 释放资源
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDictArr;
}

+ (BOOL)openDB:(NSString *)uid{
    // 创建默认的数据库
    NSString* dbName = @"common.sqlite";
    
    // 根据用户的id来创建数据库，如果uid成都为0时， 使用默认的数据库
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    
    // 拼接数据库路径
    NSString* dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    
    // 打开数据库，如果不存在，直接去创建
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

+ (void)closeDB{
    // 关闭数据库
    sqlite3_close(ppDb);
}

@end













