//
//  LockViewController.m
//  GCD实践
//
//  Created by fang wang on 16/12/30.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "LockViewController.h"

@interface LockViewController ()

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - 条件锁: 条件锁可以控制线程的执行次序，相当于NSOperation中的依赖关系

- (void)lockTest{
    /*
     常见的锁：简单介绍下iOS中常用的各种锁和他们的性能。
     
     NSRecursiveLock：递归锁，可以在一个线程中反复获取锁不会造成死锁，这个过程会记录获取锁和释放锁的次数来达到何时释放的作用。
     NSDistributedLock：分布锁，基于文件方式的锁机制，可以跨进程访问。
     NSConditionLock：条件锁，用户定义条件，确保一个线程可以获取满足一定条件的锁。因为线程间竞争会涉及到条件锁检测，系统调用上下切换频繁导致耗时是几个锁里最长的。
     OSSpinLock：自旋锁，不进入内核，减少上下文切换，性能最高，但抢占多时会占用较多cpu，好点多，这时使用pthread_mutex较好。
     pthread_mutex_t：同步锁基于C语言，底层api性能高，使用方法和其它的类似。
     @synchronized：更加简单。
     */
    //条件锁,条件是整数值
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:3];
    //不要在外面加锁，那样锁的是主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加锁
        [lock lockWhenCondition:3];
        NSLog(@"111111111111");
        //解锁
        [lock unlockWithCondition:4];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加锁
        [lock lockWhenCondition:4];
        NSLog(@"222222222222");
        //解锁
        [lock unlock];
    });
}

#pragma mark - 递归锁使用
- (void)recursionLock{
    
    NSRecursiveLock *lock =[[NSRecursiveLock alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveMethod)(int);
        RecursiveMethod = ^(int value){
            [lock lock];
            if (value > 0) {
                NSLog(@"value = %d",value);
                sleep(2);
                RecursiveMethod(value - 1);
            }
            [lock unlock];
        };
        RecursiveMethod(5);
    });
    
    //尝试在第二个线程中枷锁
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        BOOL flag = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        if (flag) {
            NSLog(@"Lock before date");
            [lock unlock];
        }else{
            NSLog(@"fail to lock before date");
        }
    });
}


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

@end
