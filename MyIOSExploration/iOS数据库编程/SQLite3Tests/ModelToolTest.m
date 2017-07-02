//
//  ModelToolTest.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ModelTool.h"
#import "WDYStu.h"

@interface ModelToolTest : XCTestCase

@end

@implementation ModelToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIvarNameType {
    
    NSDictionary* dict = [ModelTool classIvarNameTypeDict:[WDYStu class]];
    NSLog(@"dict = %@", dict);
}

-(void)testIvarNameSQLiteType{
    NSDictionary* dict = [ModelTool classIvarNameSqliteTypeDict:[WDYStu class]];
    NSLog(@"dict = %@", dict);
}

- (void)testColumnNameAndTypes{
    
    NSString* result = [ModelTool columnNameAndTypesStr:[WDYStu class]];
    NSLog(@"result = %@", result);
    
    //打印结果： result = age integer,stuNum integer,score real,name text
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
