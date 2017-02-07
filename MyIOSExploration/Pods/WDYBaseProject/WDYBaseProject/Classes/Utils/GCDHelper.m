//
//  GCDHelper.m
//  Pods
//
//  Created by fang wang on 16/12/29.
//

#import "GCDHelper.h"
#import <mach/mach_time.h>
#import <libkern/OSAtomic.h>

#pragma mark-  GCDGroup

@interface GCDGroup ()

@property (strong, nonatomic, readwrite) dispatch_group_t dispatchGroup;

@end

@implementation GCDGroup

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchGroup = dispatch_group_create();
    }
    
    return self;
}

- (void)enter {
    
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
    
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
    
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end


#pragma mark-  GCDQueue

static GCDQueue *mainQueue_;
static GCDQueue *globalQueue_;
static GCDQueue *highPriorityGlobalQueue_;
static GCDQueue *lowPriorityGlobalQueue_;
static GCDQueue *backgroundPriorityGlobalQueue_;

@interface GCDQueue ()

@property (strong, readwrite, nonatomic) dispatch_queue_t dispatchQueue;

@end

@implementation GCDQueue

+ (GCDQueue *)mainQueue {
    
    return mainQueue_;
}

+ (GCDQueue *)globalQueue {
    
    return globalQueue_;
}

+ (GCDQueue *)highPriorityGlobalQueue {
    
    return highPriorityGlobalQueue_;
}

+ (GCDQueue *)lowPriorityGlobalQueue {
    
    return lowPriorityGlobalQueue_;
}

+ (GCDQueue *)backgroundPriorityGlobalQueue {
    
    return backgroundPriorityGlobalQueue_;
}

+ (void)initialize {
    
    /**
     1.确保只被调用一次，
     2.如果在分类中需要调用，重写方法
     3.initialize初始化是线程安全的
     */
    if (self == [GCDQueue self])  {

        mainQueue_                     = [GCDQueue new];
        globalQueue_                   = [GCDQueue new];
        highPriorityGlobalQueue_       = [GCDQueue new];
        lowPriorityGlobalQueue_     = [GCDQueue new];
        backgroundPriorityGlobalQueue_ = [GCDQueue new];
        
        mainQueue_.dispatchQueue                     = dispatch_get_main_queue();
        globalQueue_.dispatchQueue                   = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        highPriorityGlobalQueue_.dispatchQueue       = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        lowPriorityGlobalQueue_.dispatchQueue        = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        backgroundPriorityGlobalQueue_.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
}

- (instancetype)init {
    
    return [self initSerial];
}

- (instancetype)initSerial {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (instancetype)initSerialWithLabel:(NSString *)label {
    
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (instancetype)initConcurrent {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (instancetype)initConcurrentWithLabel:(NSString *)label {
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)execute:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), self.dispatchQueue, block);
}

- (void)waitExecute:(dispatch_block_t)block {
    
    /*
     这个方法尽量在当前线程池中调用.
     */
    
    NSParameterAssert(block);
    dispatch_sync(self.dispatchQueue, block);
}

- (void)barrierExecute:(dispatch_block_t)block {
    
    /*
     使用的线程池应该是你自己创建的并发线程池.如果你传进来的参数为串行线程池
     或者是系统的并发线程池中的某一个,这个方法就会被当做一个普通的async操作
     */
    
    NSParameterAssert(block);
    dispatch_barrier_async(self.dispatchQueue, block);
}

- (void)waitBarrierExecute:(dispatch_block_t)block {
    
    /*
     1.使用的线程池应该是你自己创建的并发线程池.如果你传进来的参数为串行线程池
     或者是系统的并发线程池中的某一个,这个方法就会被当做一个普通的sync操作
     2.这个方法尽量在当前线程池中调用.
     */
    
    NSParameterAssert(block);
    dispatch_barrier_sync(self.dispatchQueue, block);
}

- (void)suspend {
    
    dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
    
    dispatch_resume(self.dispatchQueue);
}

- (void)execute:(dispatch_block_t)block inGroup:(GCDGroup *)group {
    
    NSParameterAssert(block);
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)notify:(dispatch_block_t)block inGroup:(GCDGroup *)group {
    
    NSParameterAssert(block);
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

#pragma mark-  Class Methods

+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), mainQueue_.dispatchQueue, block);
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), globalQueue_.dispatchQueue, block);
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), highPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), lowPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), backgroundPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInMainQueue:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(mainQueue_.dispatchQueue, block);
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(globalQueue_.dispatchQueue, block);
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(highPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(lowPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block {
    
    NSParameterAssert(block);
    dispatch_async(backgroundPriorityGlobalQueue_.dispatchQueue, block);
}

@end


#pragma mark-  GCDSemaphore

@interface GCDSemaphore ()

@property (strong, readwrite, nonatomic) dispatch_semaphore_t dispatchSemaphore;

@end

@implementation GCDSemaphore

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSemaphore = dispatch_semaphore_create(0);
    }
    
    return self;
}

- (instancetype)initWithValue:(long)value {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    
    return self;
}

- (BOOL)signal {
    
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait {
    
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end


#pragma mark-  GCDTimer

@interface GCDTimer ()

@property (strong, readwrite, nonatomic) dispatch_source_t dispatchSource;

@end

@implementation GCDTimer

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    
    return self;
}

- (instancetype)initInQueue:(GCDQueue *)queue {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue);
    }
    
    return self;
}

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delay), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)event:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)start {
    
    dispatch_resume(self.dispatchSource);
}

- (void)destroy {
    
    dispatch_source_cancel(self.dispatchSource);
}

@end


#pragma mark-   在主线程加载

void Run_Main(dispatch_block_t RunMain) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (RunMain) RunMain();
    });
}

#pragma mark-   异步加载 回到主线程刷新UI

void Run_Async(dispatch_block_t RunAsync, dispatch_block_t RunMain) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (RunAsync) RunAsync();
        if (RunMain) Run_Main(RunMain);
    });
}

#pragma mark-   延迟加载

void Run_Delay(CGFloat Seconds ,dispatch_block_t RunDelay) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (RunDelay) RunDelay();
    });
}

#pragma mark-   线程加锁

void Run_Lock_GCD(void (^RunLock)(dispatch_semaphore_t sema)) {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    RunLock(sema);
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

void Run_Lock_OSSpin(dispatch_block_t RunLock) {
    OSSpinLock spinLock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&spinLock);
    RunLock();
    OSSpinLockUnlock(&spinLock);
}

#pragma clang diagnostic pop

#pragma mark-   检查block内执行的代码块花费的时间 来判断是否需要优化

void Run_TakeTime (dispatch_block_t block, NSString *message) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        block();
        return;
    };
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    NSLog(@"%s: Took [%f] seconds to [%@]", __PRETTY_FUNCTION__, (CGFloat)nanos / NSEC_PER_SEC, message);
}
