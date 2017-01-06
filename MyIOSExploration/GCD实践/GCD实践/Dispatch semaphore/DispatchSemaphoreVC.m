//
//  DispatchSemaphoreVC.m
//  GCD实践
//
//  Created by fang wang on 16/12/30.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "DispatchSemaphoreVC.h"

@interface DispatchSemaphoreVC ()

@end

@implementation DispatchSemaphoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 资源抢夺的例子
    [self demo];
}

- (void)demo{
    /*应用场景1：马路有2股道，3辆车通过 ，每辆车通过需要2秒
     *条件分解:
     马路有2股道 <=>  dispatch_semaphore_create(2) //创建两个信号
     三楼车通过 <=> dispatch_async(defaultQueue, ^{ } 执行三次
     车通过需要2秒 <=>  [NSThread sleepForTimeInterval:2];//线程暂停两秒
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"carA pass the road");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"carB pass the road");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [NSThread sleepForTimeInterval:2];
        NSLog(@"carC pass the road");
        dispatch_semaphore_signal(semaphore);
    });
    NSLog(@"GCDFunction end");
    /*
    2017-01-06 17:46:15.062 GCD实践[57990:3548129] GCDFunction end
    2017-01-06 17:46:17.066 GCD实践[57990:3548266] carA pass the road
    2017-01-06 17:46:17.066 GCD实践[57990:3548965] carB pass the road
    2017-01-06 17:46:19.067 GCD实践[57990:3548967] carC pass the road
    */
}

// 首先举个反例，看看打印
- (void)demo1{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray* arr = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 1000; i++) {
        dispatch_group_async(group, queue, ^{
            [arr addObject:[NSNumber numberWithInteger:i]]; // 这里会崩溃
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"%@", @([arr count]));
}

// 解决方法一：串行队列
- (void)demo2{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < 1000; i++) {
        dispatch_sync(queue, ^{
            [arr addObject:[NSNumber numberWithInteger:i]];
        });
    }
    NSLog(@"%@", @([arr count]));
}

// 解决方案二：队列组的 dispatch_group_enter 和 dispatch_group_leave
- (void)demo3{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0; i < 1000; i++) {
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [array addObject:[NSNumber numberWithInt:i]];
            dispatch_group_leave(group);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"%@", @([array count]));
}

// 解决方法三：dispatch_semaphore_t 信号量
//应用场景2 ：原子性保护，保证同时只有一个线程进入操作
- (void)demo4{
    // 创建一个自定义的队列
    dispatch_queue_t queue = dispatch_queue_create("com.wdy.myiosexploration", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    
    NSMutableArray* arr = [NSMutableArray array];
    
    for (int i = 0; i < 10000; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);   // 减“1”
            NSLog(@"⬇️ = %@",[NSThread currentThread]);
            [arr addObject:[NSNumber numberWithInteger:i]];
        });
        dispatch_semaphore_signal(sem); // 加“1”
    }
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, @([arr count]));
    });
}

/* 
 停车场的例子 来理解 dispatch_semaphore_t
 
 以一个停车场是运作为例。为了简单起见，假设停车场只有三个车位，一开始三个车位都是空的。这时如果同时来了五辆车，看门人允许其中三辆不受阻碍的进入，
 然后放下车拦，剩下的车则必须在入口等待，此后来的车也都不得不在入口处等待。这时，有一辆车离开停车场，看门人得知后，打开车拦，放入一辆，
 如果又离开两辆，则又可以放入两辆，如此往复。
 
 在这个停车场系统中，车位是公共资源，每辆车好比一个线程，看门人起的就是信号量的作用。 
 更进一步，信号量的特性如下：信号量是一个非负整数（车位数），所有通过它的线程（车辆）都会将该整数减一（通过它当然是为了使用资源），
 当该整数值为零时，所有试图通过它的线程都将处于等待状态。在信号量上我们定义两种操作： Wait（等待） 和 Release（释放）。 
 当一个线程调用Wait（等待）操作时，它要么通过然后将信号量减一，要么一直等下去，直到信号量大于一或超时。Release（释放）实际上是在信号量上执行加操作，
 对应于车辆离开停车场，该操作之所以叫做“释放”是因为加操作实际上是释放了由信号量守护的资源。
 
 参考资料： 
 http://www.cnblogs.com/snailHL/p/3906112.html
 https://github.com/ChenYilong/ParseSourceCodeStudy/blob/master/01_Parse%E7%9A%84%E5%A4%9A%E7%BA%BF%E7%A8%8B%E5%A4%84%E7%90%86%E6%80%9D%E8%B7%AF/Parse%E7%9A%84%E5%BA%95%E5%B1%82%E5%A4%9A%E7%BA%BF%E7%A8%8B%E5%A4%84%E7%90%86%E6%80%9D%E8%B7%AF.md
 
 */

// GCD 通过 信号量 来控制并发数
- (void)demo5{

    // 因为用到了dispatch_barrier_async，该函数只能搭配自定义并行队列dispatch_queue_t使用。所以不能使用：dispatch_get_global_queue
    dispatch_queue_t queue = dispatch_queue_create("com.wdy.myiosexploration", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < 10000; i++) {
        dispatch_async_limit(queue, 1, ^{
            NSLog(@"⬇️ = %@",[NSThread currentThread]);
            [arr addObject:[NSNumber numberWithInteger:i]];
        });
    }
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, @([arr count]));
    });
}

/*
 *
 实战版本：具有专门控制并发等待的线程，优点是不会阻塞主线程，可以跑一下 demo，你会发现主屏幕上的按钮是可点击的。但相应的，viewdidload 方法中的栅栏方法dispatch_barrier_async就失去了自己的作用：无法达到“等为数组遍历添加元素后，检查下数组的成员个数是否正确”的效果。
 *
 */
void dispatch_async_limit(dispatch_queue_t queue,NSUInteger limitSemaphoreCount, dispatch_block_t block) {
    //控制并发数的信号量
    static dispatch_semaphore_t limitSemaphore;
    //专门控制并发等待的线程
    static dispatch_queue_t receiverQueue;
    
    //使用 dispatch_once而非 lazy 模式，防止可能的多线程抢占问题
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitSemaphore = dispatch_semaphore_create(limitSemaphoreCount);
        receiverQueue = dispatch_queue_create("receiver", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(receiverQueue, ^{
        //可用信号量后才能继续，否则等待
        dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            !block ? : block();
            //在该工作线程执行完成后释放信号量
            dispatch_semaphore_signal(limitSemaphore);
        });
    });
}

@end








