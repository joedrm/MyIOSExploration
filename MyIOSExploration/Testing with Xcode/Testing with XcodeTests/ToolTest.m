//
//  ToolTest.m
//  Testing with Xcode
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 wallan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Tool.h"

@interface ToolTest : XCTestCase

@end

@implementation ToolTest

// 测试开始前调用
- (void)setUp {
    [super setUp];
}

// 测试结束调用
- (void)tearDown {
    [super tearDown];
}

// 测试用例
- (void)testExample {
    
}

// 快捷键： commond + u 跑测试用例
- (void)testAdd{

    int result = [Tool add:3 b:4];
    XCTAssertEqual(result, 7);
    
    int result2 = [Tool devide:8 b:2];
    XCTAssertEqual(result2, 4);
    
//    int result3 = [Tool devide:5 b:0];
//    XCTAssertEqual(result3, 0);
}

// 性能测试
- (void)testPerformanceExample {
    
    [self measureBlock:^{
        
    }];
}
@end
