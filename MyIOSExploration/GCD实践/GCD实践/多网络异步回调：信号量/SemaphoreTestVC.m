//
//  SemaphoreTestVC.m
//  GCD实践
//
//  Created by fang wang on 16/12/22.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "SemaphoreTestVC.h"

@interface SemaphoreTestVC ()

@end

@implementation SemaphoreTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    NSArray  * resultArray = [self fetchDataFromServe];
//    NSLog(@"resultArrsy = %@",resultArray);
    
    //    NSArray  * resultArray = [self semaphore_fetchDataFromServe];
    //    NSLog(@"resultArrsy = %@",resultArray);
    
    NSArray  * resultArray = [self group_fetchDataFromServe];
    NSLog(@"resultArrsy = %@",resultArray);
}

// 在没有考虑到异步的情况下，这样写
- (__kindof NSArray  *)fetchDataFromServe{
    
    //假如下面这个数组是用来存放数据的
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    //下面这个来代替我们平时常用的异步网络请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 4; i ++) {
            [array addObject:[NSNumber numberWithInt:i]];
        }
        NSLog(@"array = %@",array);
        
    });
    return array;
    /*打印结果
     2016-12-22 16:41:50.592 GCD实践[43635:1731330] resultArrsy = (
     )
     2016-12-22 16:41:50.592 GCD实践[43635:1732279] array = (
         0,
         1,
         2,
         3,
         4
     )
     */
}

// 使用信号量控制
- (__kindof NSArray  *)semaphore_fetchDataFromServe{
    
    //修改下面的代码，使用信号量来进行一个同步数据
    //我们传入一个参数0 ，表示没有资源，非0 表示是有资源，这一点需要搞清楚
    //补充：这里的整形参数如果是非0 就是总资源
    dispatch_semaphore_t semaoh = dispatch_semaphore_create(0);
    
    //假如下面这个数组是用来存放数据的
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    //下面这个来代替我们平时常用的异步网络请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<4; i++) {
            [array addObject:[NSNumber numberWithInt:i]];
            
        }
        NSLog(@"array = %@",array);
        //发送信号，信号量  管理资源数+1  车辆如果遇到绿色信号灯，等待的车辆就会减少，也就是资源数减少，一直减少到 dispatch_semaphore_wait  这个函数返回 0 才会继续执行，
        dispatch_semaphore_signal(semaoh);
        
    });
    //信号等待 时，资源数 -1  阻塞当前线程
    dispatch_semaphore_wait(semaoh, DISPATCH_TIME_FOREVER);
    
    return array;
    
    /* 打印结果
    2016-12-22 16:45:47.785 GCD实践[43710:1734722] array = (
                                                          0,
                                                          1,
                                                          2,
                                                          3,
                                                          4
                                                          )
    2016-12-22 16:45:47.785 GCD实践[43710:1734678] resultArrsy = (
                                                                0,
                                                                1,
                                                                2,
                                                                3,
                                                                4
                                                                )

    */
}

// 使用dispatch_group_t
- (NSArray *)group_fetchDataFromServe{
    
    //使用GCD创建一个group 组，
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray * array = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        // dispatch_group_leave和dispatch_group_leave  这两个必须是成对出现，缺一不可，如果对应不上则会出现线程阻塞，
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [array addObject:[NSNumber numberWithInt:i]];
            //dispatch_group_leave
            dispatch_group_leave(group);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"array = %@",array);
    return array;
    
    /*
    2016-12-22 16:55:43.935 GCD实践[43808:1741927] array = (
                                                          0,
                                                          1,
                                                          2,
                                                          3,
                                                          4
                                                          )
    2016-12-22 16:55:43.935 GCD实践[43808:1741927] resultArrsy = (
                                                                0,
                                                                1,
                                                                2,
                                                                3,
                                                                4
                                                                )
    */
}

/*
 小结：
 
 以上几种方法适合我们在做一些简单的遍历操作的时候挺适合的，针对请求的一些异步数据，还是提醒一点，使用这个一定要注意是否有嵌套主线程，造成线程阻塞，
 如果使用了AF嵌套，AF缺省的时候是主线程，而我们的wait 函数也是主线程，此时会造成死锁，平时使用的时候要注意这一点
 */


// 常见的读写操作例子： 每次只允许一个线程进行读写操作
- (void)semDemo{
    
    //这里我们指定一个资源 wait 返回值就不会为0 执行发出信号操作
    dispatch_semaphore_t semat = dispatch_semaphore_create(1);
    NSMutableArray * array = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i=0; i<1000; i++) {
            dispatch_semaphore_wait(semat, DISPATCH_TIME_FOREVER);
            [array addObject:[NSNumber numberWithInt:i]];
            dispatch_semaphore_signal(semat);
        }
    });
}

@end
