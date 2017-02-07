//
//  GCDHelper.h
//  Pods
//
//  Created by fang wang on 16/12/29.
//

/*
 参考：https://github.com/wujunyang/MobileProject/blob/master/MobileProject/Expand/Tool/GCDHelper/GCD.h
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 主线程运行 */
FOUNDATION_EXTERN void Run_Main(dispatch_block_t RunMain);

/** 异步加载 回到主线程 */
FOUNDATION_EXTERN void Run_Async(dispatch_block_t RunAsync, dispatch_block_t RunMain);

/** 延迟加载 */
FOUNDATION_EXTERN void Run_Delay(CGFloat Seconds ,dispatch_block_t RunDelay);

/** 使用GCD加线程锁  操作完成后加上 dispatch_semaphore_signal(sema) */
FOUNDATION_EXTERN void Run_Lock_GCD(void (^RunLock)(dispatch_semaphore_t sema));

/** 使用OSSpinLock加线程锁 */
FOUNDATION_EXTERN void Run_Lock_OSSpin(dispatch_block_t RunLock);

/** block内代码块执行所花费的时间 */
FOUNDATION_EXTERN void Run_TakeTime (dispatch_block_t block, NSString *message);

#pragma mark-  GCDGroup

@interface GCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

- (instancetype)init;

- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end


#pragma mark-  GCDQueue

@interface GCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;

+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

- (instancetype)init;
- (instancetype)initSerial;
- (instancetype)initSerialWithLabel:(NSString *)label;
- (instancetype)initConcurrent;
- (instancetype)initConcurrentWithLabel:(NSString *)label;

- (void)execute:(dispatch_block_t)block;
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;
- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta;
- (void)waitExecute:(dispatch_block_t)block;
- (void)barrierExecute:(dispatch_block_t)block;
- (void)waitBarrierExecute:(dispatch_block_t)block;
- (void)suspend;
- (void)resume;

- (void)execute:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)notify:(dispatch_block_t)block inGroup:(GCDGroup *)group;

@end


#pragma mark-  GCDSemaphore

@interface GCDSemaphore : NSObject

@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

- (instancetype)init;
- (instancetype)initWithValue:(long)value;

- (BOOL)signal;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end


#pragma mark-  GCDTimer

@interface GCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

- (instancetype)init;
- (instancetype)initInQueue:(GCDQueue *)queue;

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay;
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs;
- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;
- (void)start;
- (void)destroy;

@end


