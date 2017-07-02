//
//  SQLiteToolTest.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SQLiteTool.h"

@interface SQLiteToolTest : XCTestCase

@end

@implementation SQLiteToolTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testExample {
    
    NSString* sql = @"create table if not exists t_stu(id integer primary key autoincrement, name test not null, age integer, score real)";
    BOOL result = [SQLiteTool dealWithSql:sql uid:nil];
    XCTAssertEqual(result, YES);
}

- (void)testQuery{

    NSString* sql = @"select * from t_stu";
    NSMutableArray* result = [SQLiteTool querySql:sql uid:nil];
    
    NSLog(@"%@", result);
}



- (void)testPerformanceExample {
    
    [self measureBlock:^{
        
    }];
}

@end
