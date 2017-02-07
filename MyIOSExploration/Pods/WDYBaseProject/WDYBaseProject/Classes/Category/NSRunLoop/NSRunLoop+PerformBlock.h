//
//  NSRunLoop+PerformBlock.h
//  Pods
//
//  Created by fang wang on 17/1/3.
//
///  https://github.com/ishkawa/NSRunLoop-PerformBlock

/* 使用
- (void)testPerformBlockAndWait
{
    // 1
    __block BOOL flag = NO;
    
    [[NSRunLoop currentRunLoop] performBlockAndWait:^(BOOL *finish) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_after(popTime, queue, ^(void){
            // 2
            flag = YES;
            *finish = YES;
        });
    }];
    
    // 3
    XCTAssertTrue(flag);
}

*/

#import <Foundation/Foundation.h>

@interface NSRunLoop (PerformBlock)

- (void)performBlockAndWait:(void (^)(BOOL *finish))block;


- (void)performBlockAndWait:(void (^)(BOOL *finish))block timeoutInterval:(NSTimeInterval)timeoutInterval;


@end
