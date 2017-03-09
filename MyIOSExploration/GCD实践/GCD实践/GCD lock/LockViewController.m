//
//  LockViewController.m
//  GCD实践
//
//  Created by fang wang on 16/12/30.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "LockViewController.h"
#import <libkern/OSAtomic.h>
#import <pthread/pthread.h>

@interface LockViewController ()

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 参考文章
     http://www.chaisong.xyz/2017/02/06/2017-02-06/  从同步锁到多线程
     http://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/  不再安全的 OSSpinLock
     https://bestswifter.com/ios-lock/     深入理解 iOS 开发中的锁
     http://www.jianshu.com/p/ddbe44064ca4  iOS 常见知识点（三）：Lock
     http://www.jianshu.com/p/938d68ed832c   iOS中保证线程安全的几种方式与性能对比
     */
    
}



#pragma mark - 自旋锁 OSSpinLock
- (void)OSSpinLockTest{
    
    __block OSSpinLock oslock = OS_SPINLOCK_INIT;
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"线程2 准备上锁");
        OSSpinLockLock(&oslock);
        NSLog(@"线程2");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程2 解锁成功");
    });
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"线程1 准备上锁");
        OSSpinLockLock(&oslock);
        NSLog(@"线程1 sleep");
        sleep(4);
        NSLog(@"线程1");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程1 解锁成功");
    });
    
    // 结论：
    // 1. 虽然YY大神http://blog.ibireme.com/说其已经不再安全，但GCD在多线程实际应用过程中，未发现问题，并行线程只要获取到oslock，其它线程一律阻塞（非睡眠），直到之前获取的解锁为止，上述代码QUEUE优先级相差较大，在实际使用中未发生高优先级忙等状态
    // 2. 优先级反转：低优先级线程拿到锁时，高优先级线程进入忙等(busy-wait)状态，消耗大量 CPU 时间，从而导致低优先级线程拿不到 CPU 时间，也就无法完成任务并释放锁。
    // 3. 可以在同一线程无限制上锁，但必须成对出现解锁，否则会死锁。可以在同一线程无限制调用解锁，但如果没有获取锁，解锁代码无效。
    // 4. QUEUE的优先级和CPU调度的线程优先级可能并不是一回事，实际运用GCD来进行多线程开发时，可以应用自旋锁进行数据同步
}




#pragma mark - 信号量 dispatch_semaphore

- (void)semaphoreTest{

    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 等待ing");
        dispatch_semaphore_wait(signal, timeout); //signal 值 -1
        NSLog(@"线程1 sleep");
        sleep(2);
        NSLog(@"线程1");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程1 发送信号");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 等待ing");
        dispatch_semaphore_wait(signal, timeout);
        NSLog(@"线程2 sleep");
        sleep(2);
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal);
        NSLog(@"线程2 发送信号");
    });
    /*
         2017-03-09 10:28:02.029 GCD实践[1866:60381] 线程1 等待ing
         2017-03-09 10:28:02.029 GCD实践[1866:60625] 线程2 等待ing
         2017-03-09 10:28:02.029 GCD实践[1866:60381] 线程1 sleep
         2017-03-09 10:28:04.034 GCD实践[1866:60381] 线程1
         2017-03-09 10:28:04.034 GCD实践[1866:60381] 线程1 发送信号
         2017-03-09 10:28:04.034 GCD实践[1866:60625] 线程2 sleep
         2017-03-09 10:28:06.039 GCD实践[1866:60625] 线程2
         2017-03-09 10:28:06.040 GCD实践[1866:60625] 线程2 发送信号
     
     信号量dispatch_semaphore被称为spinlock的替代方案。（引http://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/）
     使用方法非常简单，dispatch_semaphore_create(1)为创建信号，数字表示可以同时几个线程使用信号。为1表示同步使用。上述代码如果此处标2就和没设置信号量一样，并发自行运行。如果设置为0，则一律等待overTime时自动释放，所有代码都不执行，理论上也具有同步作用，就是慢点…
     dispatch_semaphore_wait中传入的timeout表示最长加锁时间，此处sleep如果为4，则在3s后会自动释放锁，其它线程可以获取信号并继续运行。
     
     和厕所坑位类似，dispatch_semaphore_create(1)表示只有1个坑位，timeout = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC)表示坑位只能占用3秒。无论是否当前线程，坑位都一致。可以在同一线程频繁调用dispatch_semaphore_wait，在只有一个坑位且没有dispatch_semaphore_signal信号情况下，会等到每次的timeout。所以理论上可以不成对出现。
     */
}



#pragma mark - 互斥锁 pthread_mutex
- (void)pthread_mutexTest{

    static pthread_mutex_t pLock;
    pthread_mutex_init(&pLock, NULL);
    
    //1.线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"线程2 准备上锁");
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
    });
    
    //2.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        pthread_mutex_lock(&pLock);
        sleep(3);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
    });
    
    /*
     pthread 表示 POSIX thread，定义了一组跨平台的线程相关的 API，pthread_mutex 表示互斥锁。
     使用上没啥说的，测试效果和上文一致。
     非递归锁，同一线程重复调用加锁会造成死锁。
     
     */
}




#pragma mark - pthread_mutex(recursive) 递归锁

- (void)recursionLockTest{

    static pthread_mutex_t pLock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
    pthread_mutex_init(&pLock, &attr);
    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
    
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                NSLog(@"value: %d", value);
                RecursiveBlock(value - 1);
            }
            
        };
        NSLog(@"线程1 准备上锁");
        RecursiveBlock(5);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
        NSLog(@"线程1 解锁");
    });
    
    //2.线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
        NSLog(@"线程2 解锁");
    });
    // 递归锁比较安全，可以认为同一线程加且仅加一次锁，重复加锁不会造成死锁。无论同一线程加锁多少次，解锁1次即可
}






#pragma mark - NS前缀的两个锁NSLock、NSRecursiveLock

- (void)NSLockAndNSRecursiveLockTest{

    NSLock *lock = [NSLock new];
    [lock lock];
    NSLog(@"加锁运行");
    [lock unlock];
    
    NSRecursiveLock *recursiveLock = [NSRecursiveLock new];
    [recursiveLock lock];
    NSLog(@"加锁运行");
    [recursiveLock unlock];
    
    /*
     NS开头的类都是对CoreFoundation的封装，只是易用一些。NSRecursiveLock为递归锁，可以在循环和递归中使用。
     这里NSLock和NSRecursiveLock都是封装的互斥锁pthread_mutex。
     NSLock 只是在内部封装了一个 pthread_mutex，属性为 PTHREAD_MUTEX_ERRORCHECK，它会损失一定性能换来错误提示。理论上 NSLock 和 pthread_mutex 拥有相同的运行效率，实际由于封装的原因，会略慢一点，由于有缓存存在，相差不会很多，属于相同数量级。
     NSRecursiveLock 与 NSLock 的区别在于内部封装的 pthread_mutex_t 对象的类型不同，NSRecursiveLock 的类型为 PTHREAD_MUTEX_RECURSIVE。
     
     */
}





#pragma mark - 条件锁 NSConditionLock

- (void)NSConditionLockTest{

    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程2");
        [cLock unlockWithCondition:3];
    });
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
            [cLock unlockWithCondition:1];
        }else{
            NSLog(@"失败");
        }
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"线程3");
        [cLock unlockWithCondition:2];
    });
    
    /*  线程1–>线程2–>线程3按顺序执行
         2017-03-09 10:41:53.274 GCD实践[1992:71454] 线程1
         2017-03-09 10:41:53.275 GCD实践[1992:71472] 线程2
         2017-03-09 10:41:53.275 GCD实践[1992:71452] 线程3
     
     NSCondition
     顾明思意，条件锁，一种生产者—消费者模型。
     它通常用于标明共享资源是否可被访问或者确保一系列任务能按照指定的执行顺序执行。如果一个线程试图访问一个共享资源，而正在访问该资源的线程将其条件设置为不可访问，
     那么该线程会被阻塞，直到正在访问该资源的线程将访问条件更改为可访问状态或者说给被阻塞的线程发送信号后，被阻塞的线程才能正常访问这个资源。
     
     实际的实现原理就是里面封装了一个NSCondition对象，在lock时判断NSCondition对象的条件是否满足，
     不满足则wait，unlock时对发送NSCondition的broadcast，属于一个常见的生产者–消费者模型。
     */
}



#pragma mark - 简单易用的条件锁 @synchronized

- (void)synchronizedTest{

    @synchronized (self) {
        NSLog(@"加锁运行");
    }
    
    /*
     @synchronized 实际上是把修饰对象当做锁来使用。这是通过一个哈希表来实现的，
     OC 在底层使用了一个互斥锁的数组(你可以理解为锁池)，通过对对象去哈希值来得到对应的互斥锁。
     */
}





/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 5S下测试一千万次加锁解锁时间测试
 
*/
#define ITERATIONS (10000000) // 1千万
- (void)test
{
    double then, now;
    
    @autoreleasepool {
        
        // 普通锁 NSLock
        NSLock *lock = [NSLock new];
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            [lock lock];
            [lock unlock];
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"NSLock: %f sec\n", now-then);
        
        // 互斥锁 pthread_mutex
        pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            pthread_mutex_lock(&mutex);
            pthread_mutex_unlock(&mutex);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"pthread_mutex: %f sec\n", now-then);
        
        // 递归锁 pthread_mutex(recursive)
        static pthread_mutex_t pLock;
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
        pthread_mutex_init(&pLock, &attr);
        pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
        
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            pthread_mutex_lock(&pLock);
            pthread_mutex_unlock(&pLock);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"pthread_mutex(recursive): %f sec\n", now-then);
        
        // 自旋锁 OSSpinlock
        OSSpinLock spinlock = OS_SPINLOCK_INIT;
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            OSSpinLockLock(&spinlock);
            OSSpinLockUnlock(&spinlock);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"OSSpinlock: %f sec\n", now-then);
        
        // synchronized
        id obj = [NSObject new];
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            @synchronized(obj)
            {
            }
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"@synchronized: %f sec\n", now-then);
        
        // dispatch_semaphore
        dispatch_semaphore_t lockSemaphore = dispatch_semaphore_create(1);
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            dispatch_semaphore_wait(lockSemaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_signal(lockSemaphore);
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"dispatch_semaphore: %f sec\n", now-then);
        
        
        NSCondition *cLock = [NSCondition new];
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            [cLock lock];
            [cLock unlock];
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"NSCondition: %f sec\n", now-then);
        
        
        NSRecursiveLock *rLock = [NSRecursiveLock new];
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            [rLock lock];
            [rLock unlock];
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"NSRecursiveLock: %f sec\n", now-then);
        
        // dispatch_barrier_async
        dispatch_queue_t queue = dispatch_queue_create("xyz.chaisong.lock", DISPATCH_QUEUE_SERIAL);
        then = CFAbsoluteTimeGetCurrent();
        for(NSInteger i = 0; i < ITERATIONS; ++i)
        {
            dispatch_barrier_async(queue, ^{
            });
        }
        now = CFAbsoluteTimeGetCurrent();
        NSLog(@"dispatch_barrier_async: %f sec\n", now-then);
    }
}

/*

 2017-03-09 10:50:53.333 GCD实践[2074:77657] NSLock: 0.319628 sec
 2017-03-09 10:50:53.557 GCD实践[2074:77657] pthread_mutex: 0.223835 sec
 2017-03-09 10:50:53.901 GCD实践[2074:77657] pthread_mutex(recursive): 0.343985 sec
 2017-03-09 10:50:54.008 GCD实践[2074:77657] OSSpinlock: 0.106090 sec
 2017-03-09 10:50:55.092 GCD实践[2074:77657] @synchronized: 1.084173 sec
 2017-03-09 10:50:55.268 GCD实践[2074:77657] dispatch_semaphore: 0.175534 sec
 2017-03-09 10:50:55.572 GCD实践[2074:77657] NSCondition: 0.303844 sec
 2017-03-09 10:50:56.015 GCD实践[2074:77657] NSRecursiveLock: 0.441846 sec
 2017-03-09 10:51:07.667 GCD实践[2074:77657] dispatch_barrier_async: 11.651558 sec

 结论：
 单从效率上来看 dispatch_barrier_async 和 @synchronized 差的比较多，不建议使用，其它整体相差不大；
 相同类型的锁递归锁和普通锁效率相差接近一倍，如果不会在循环或者递归中频繁使用加锁和解锁，不建议使用递归锁；
 OSSpinlock各路大神都说有问题，从效率上讲，建议用互斥锁pthread_mutex（YYKit方案）或者信号量dispatch_semaphore（CoreFoundation和protobuf方案）作为替代。
 OSpinlock为什么效率奇高主要原因是：并没有进入系统kernel，使用它可以节省系统调用和上下文切换。
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */





/*
 多线程中的常见术语
 
 条件(condition): 一个用来同步资源访问的结构。线程等待某一条件来决定是否被允许继续运行，直到其他线程显式的给该条件发送信号。
 临界区(critical section): 同一时间只能不被一个线程执行的代码。
 输入源(input source)：一个线程的异步事件源。输入源可以是基于端口的或手工触发，并且必须被附加到某一个线程的run loop上面。
 可连接的线程(join thread)：退出时资源不会被立即回收的线程。可连接的线程在资源被回收之前必须被显式脱离或由其他线程连接。可连接线程提供了一个返回值给连接它的线程。
 主线程(main thread)：当创建进程时一起创建的特定类型的线程。当程序的主线程退出，则程序即退出。
 互斥锁(mutex)：提供共享资源互斥访问的锁。一个互斥锁同一时间只能被一个线程拥有。试图获取一个已经被其他线程拥有的互斥锁，会把当前线程置于休眠状态知道该锁被其他线程释放并让当前线程获得。
 操作对象(operation object)：NSOperation类的实例。操作对象封装了和某一任务相关的代码和数据到一个执行单元里面。
 操作队列(operation queue)：NSOperationQueue类的实例。操作队列管理操作对象的执行。
 进程(process)：应用或程序的运行时实例。一个进程拥有独立于分配给其他程序的的内存空间和系统资源（包括端口权限）。进程总是包含至少一个线程（即主线程）和任意数量的额外线程。
 递归锁(recursive lock)：可以被同一线程多次锁住的锁。
 信号量(semaphore)：一个受保护的变量，它限制共享资源的访问。互斥锁(mutexes)和条件(conditions)都是不同类型的信号量。
 任务(task)：要执行的工作数量。尽管一些技术(最显著的是Carbon 多进程服务—Carbon Multiprocessing Services)使用该术语的意义有时不同，但是最通用的用法是表明需要执行的工作数量的抽象概念。
 线程(thread)：进程里面的一个执行过程流。每个线程都有它自己的栈空间，但除此之外同一进程的其他线程共享内存。
 优先级反转：低优先级线程拿到锁时，高优先级线程进入忙等(busy-wait)状态，消耗大量 CPU 时间，从而导致低优先级线程拿不到 CPU 时间，也就无法完成任务并释放锁。
 
 一些多线程的基础知识
 
 1、时间片轮转调度算法
 
 了解多线程加锁必须知道时间片轮转调度算法，才能深切理解其原理、性能瓶颈。
 现代操作系统在管理普通线程时，通常采用时间片轮转算法(Round Robin，简称 RR)。每个线程会被分配一段时间片(quantum)，通常在 10-100 毫秒左右。
 当线程用完属于自己的时间片以后，就会被操作系统挂起，放入等待队列中，直到下一次被分配时间片，如果线程在时间片结束前阻塞或结束，则CPU当即进行切换。
 由于线程切换需要时间，如果时间片太短，会导致大量CPU时间浪费在切换上；而如果这个时间片如果太长，会使得其它线程等待太久；
 
 2、原子操作
 狭义上的原子操作表示一条不可打断的操作，也就是说线程在执行操作过程中，不会被操作系统挂起，而是一定会执行完（理论上拥有CPU时间片无限长）。
 在单处理器环境下，一条汇编指令显然是原子操作，因为中断也要通过指令来实现，但一句高级语言的代码却不是原子的，因为它最终是由多条汇编语言完成，
 CPU在进行时间片切换时，大多都会在某条代码的执行过程中。
 但在多核处理器下，则需要硬件支持，没了解过具体实现。
 
 3、自旋锁和互斥锁
 
 都属于CPU时间分片算法下的实现保护共享资源的一种机制。都实现互斥操作，加锁后仅允许一个访问者。
 却别在于自旋锁不会使线程进入wait状态，而通过轮训不停查看是否该自旋锁的持有者已经释放的锁；对应的，互斥锁在出现锁已经被占用的情况会进入wait状态，CPU会当即切换时间片。
 
 自旋锁实现原理
 
 简单的while循环
     lock = 0;
     do{
         while(test_and_set(&lock));
         临界区
         lock = 0;
         其余部分
     } while(1)
 test_and_set用来保证条件判断的原子性操作，lock为旗标。
 自旋锁的一大缺陷是会使得线程处于忙等状态。因为如果临界区执行时间过长，其它线程就会在当前整个时间片一直处于忙等状态，浪费大量CPU时间。
 所以，如果临界区时间很短，可以使用自旋锁，否则建议使用互斥锁。
 
 互斥锁的实现原理
 互斥锁在出现锁的争夺时，未获得锁的线程会主动让出时间片，阻塞线程并睡眠，需要进行上下文切换，CPU会切换其它线程继续操作。
 主动让出时间片并不总是代表效率高。让出时间片会导致操作系统切换到另一个线程，这种上下文切换通常需要 10 微秒左右，而且至少需要两次切换。
 如果等待时间很短，比如只有几个微秒，忙等就比线程睡眠更高效。
 
 信号量的实现
     int sem_wait (sem_t *sem) {
         int *futex = (int *) sem;
         if (atomic_decrement_if_positive (futex) > 0)
         return 0;
         int err = lll_futex_wait (futex, 0);
         return -1;
     )
 信号量和互斥锁类似，都是在获取锁失败后线程进入wait状态，CPU会切换时间片。
 信号量在最终都是调用一个sem_wait方法，并原子性的判断信号量，如果对其-1后依然大于0，则直接返回，继续临界区操作，否则进入等待状态。
 */







#pragma mark - GCD死锁
// 当前串行队列里面同步执行当前串行队列就会死锁，解决的方法就是将同步的串行队列放到另外一个线程就能够解决。
- (void)deadLockCase1 {
    NSLog(@"1");
    //主队列的同步线程，按照FIFO的原则（先入先出），2排在3后面会等3执行完，但因为同步线程，3又要等2执行完，相互等待成为死锁。
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)deadLockCase2 {
    NSLog(@"1");
    //3会等2，因为2在全局并行队列里，不需要等待3，这样2执行完回到主队列，3就开始执行
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)deadLockCase3 {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(serialQueue, ^{
        NSLog(@"2");
        //串行队列里面同步一个串行队列就会死锁
        dispatch_sync(serialQueue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)deadLockCase4 {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
        //将同步的串行队列放到另外一个线程就能够解决
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}

- (void)deadLockCase5 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        //回到主线程发现死循环后面就没法执行了
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"4");
    //死循环
    while (1) {
        //
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self test];
}

@end
