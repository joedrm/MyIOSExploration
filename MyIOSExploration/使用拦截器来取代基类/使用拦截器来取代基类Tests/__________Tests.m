//
//  __________Tests.m
//  使用拦截器来取代基类Tests
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface __________Tests : XCTestCase

@end

@implementation __________Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
