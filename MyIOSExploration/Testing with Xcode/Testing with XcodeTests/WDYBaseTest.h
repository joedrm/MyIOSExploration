//
//  WDYBaseTest.h
//  Testing with Xcode
//
//  Created by wdy on 2017/6/24.
//  Copyright © 2017年 wallan. All rights reserved.
//

#import <XCTest/XCTest.h>

#define assertTrue(expr)              XCTAssertTrue((expr), @"")
#define assertFalse(expr)             XCTAssertFalse((expr), @"")
#define assertNil(a1)                 XCTAssertNil((a1), @"")
#define assertNotNil(a1)              XCTAssertNotNil((a1), @"")
#define assertEqual(a1, a2)           XCTAssertEqual((a1), (a2), @"")
#define assertEqualObjects(a1, a2)    XCTAssertEqualObjects((a1), (a2), @"")
#define assertNotEqual(a1, a2)        XCTAssertNotEqual((a1), (a2), @"")
#define assertNotEqualObjects(a1, a2) XCTAssertNotEqualObjects((a1), (a2), @"")
#define assertAccuracy(a1, a2, acc)   XCTAssertEqualWithAccuracy((a1),(a2),(acc))

#define WAIT                                                                \
do {                                                                        \
[self expectationForNotification:@"LCUnitTest" object:nil handler:nil]; \
[self waitForExpectationsWithTimeout:60 handler:nil];                   \
} while(0);

#define NOTIFY                                                                            \
do {                                                                                      \
[[NSNotificationCenter defaultCenter] postNotificationName:@"LCUnitTest" object:nil]; \
} while(0);

@interface WDYBaseTest : XCTestCase

@end
