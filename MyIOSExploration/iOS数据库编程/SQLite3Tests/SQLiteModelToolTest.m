//
//  SQLiteModelToolTest.m
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SQLiteModelTool.h"



@interface SQLiteModelToolTest : XCTestCase

@end

@implementation SQLiteModelToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    Class cls = NSClassFromString(@"WDYStu");
    BOOL result = [SQLiteModelTool createTable:cls uid:nil];
    
//    NSLog(@"%d", result);
    XCTAssertEqual(result, YES);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
