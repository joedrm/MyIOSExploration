//
//  ViewController.m
//  GCD实践
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"
#import "SingleTool.h"
#import <FMDB/FMDB.h>

@interface ViewController ()
{
    UIImage* _image01;
    UIImage* _image02;
}
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    imageView.frame = CGRectMake(0, 0, 200, 200);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self lockTest];
}

// 异步函数 + 并行队列 会开启多个子线程，队列中的任务是并发执行的
- (void)asyncConcurrent
{
    // 第一种写法
//    dispatch_queue_t queue = dispatch_queue_create("wdy", DISPATCH_QUEUE_CONCURRENT);
    
    // 第二种写法，全局并发队列
    // DISPATCH_QUEUE_PRIORITY_DEFAULT : 队列优先级，一般情况下是Deafult
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@" --------- start ----------- ");
    dispatch_async(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    NSLog(@" --------- end ----------- ");
    /* 打印结果
     2016-09-08 21:12:17.644 GCD实践[25013:508592]  --------- start -----------
     2016-09-08 21:12:17.644 GCD实践[25013:508592]  --------- end -----------
     2016-09-08 21:12:17.645 GCD实践[25013:508788] action01 --> <NSThread: 0x7fd16bc18620>{number = 2, name = (null)}
     2016-09-08 21:12:17.645 GCD实践[25013:508778] action02 --> <NSThread: 0x7fd16be06830>{number = 3, name = (null)}
     2016-09-08 21:12:17.645 GCD实践[25013:508787] action03 --> <NSThread: 0x7fd16bc8cdc0>{number = 4, name = (null)}
     */
}

// 异步函数 + 串行队列 会开启一个子线程，队列中的任务是串行执行的
- (void)asyncSerial
{
    dispatch_queue_t queue = dispatch_queue_create("wdy", DISPATCH_QUEUE_SERIAL);
    NSLog(@" --------- start ----------- ");
    dispatch_async(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    NSLog(@" --------- end ----------- ");
    /* 打印结果
     2016-09-08 21:13:00.285 GCD实践[25047:509381]  --------- start -----------
     2016-09-08 21:13:00.285 GCD实践[25047:509381]  --------- end -----------
     2016-09-08 21:13:00.285 GCD实践[25047:509431] action01 --> <NSThread: 0x7ff479611db0>{number = 2, name = (null)}
     2016-09-08 21:13:00.286 GCD实践[25047:509431] action02 --> <NSThread: 0x7ff479611db0>{number = 2, name = (null)}
     2016-09-08 21:13:00.286 GCD实践[25047:509431] action03 --> <NSThread: 0x7ff479611db0>{number = 2, name = (null)}
     */
}

// 同步函数 + 并行队列 在主线程中执行，不会开启子线程，队列中的任务是串行的
- (void)syncConcurrent
{
    dispatch_queue_t queue = dispatch_queue_create("wdy", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@" --------- start ----------- ");
    dispatch_sync(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    
    NSLog(@" --------- end ----------- ");
    /* 打印结果
     2016-09-08 21:14:06.340 GCD实践[25098:510631]  --------- start -----------
     2016-09-08 21:14:06.340 GCD实践[25098:510631] action01 --> <NSThread: 0x7fae10d02be0>{number = 1, name = main}
     2016-09-08 21:14:06.340 GCD实践[25098:510631] action02 --> <NSThread: 0x7fae10d02be0>{number = 1, name = main}
     2016-09-08 21:14:06.340 GCD实践[25098:510631] action03 --> <NSThread: 0x7fae10d02be0>{number = 1, name = main}
     2016-09-08 21:14:06.341 GCD实践[25098:510631]  --------- end -----------
     */
}

// 同步函数 + 串行队列 在主线程中执行，不会开启子线程，队列中的任务是串行的
- (void)syncSerial
{
    dispatch_queue_t queue = dispatch_queue_create("wdy", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@" --------- start ----------- ");
    dispatch_sync(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    
    NSLog(@" --------- end ----------- ");
    /* 打印结果
     2016-09-08 21:14:59.345 GCD实践[25134:511846]  --------- start -----------
     2016-09-08 21:14:59.346 GCD实践[25134:511846] action01 --> <NSThread: 0x7ffbe8500160>{number = 1, name = main}
     2016-09-08 21:14:59.346 GCD实践[25134:511846] action02 --> <NSThread: 0x7ffbe8500160>{number = 1, name = main}
     2016-09-08 21:14:59.346 GCD实践[25134:511846] action03 --> <NSThread: 0x7ffbe8500160>{number = 1, name = main}
     2016-09-08 21:14:59.346 GCD实践[25134:511846]  --------- end -----------
     */
}

// 异步函数 + 主队列 所有任务都会在主线程中执行，不会开线程
- (void)asyncMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    /* 打印结果
     2016-09-08 20:46:54.602 GCD实践[24262:493941] action01 --> <NSThread: 0x7f8109407a00>{number = 1, name = main}
     2016-09-08 20:46:54.603 GCD实践[24262:493941] action02 --> <NSThread: 0x7f8109407a00>{number = 1, name = main}
     2016-09-08 20:46:54.603 GCD实践[24262:493941] action03 --> <NSThread: 0x7f8109407a00>{number = 1, name = main}
     */
}

// 同步函数 + 主队列   ***产生死锁***
// 主队列的特点：如果主队列当前主线程有任务在执行，那么主队列会暂停调用队列中任务，直到主线程空闲为止
// 如果该方法在子线程中执行，那么所有任务在主线程中执行
// [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];就不会死锁
- (void)syncMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@" --------- start ----------- ");
    // 同步函数：如果当前我没有执行完毕，后面别想执行
    dispatch_sync(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    
    NSLog(@" --------- end ----------- ");
    /* 打印结果
     2016-09-08 20:48:17.985 GCD实践[24322:494998]  --------- start -----------
     */
}

#pragma mark - 自定义队列的优先级：
// 可以通过dipatch_queue_attr_make_with_qos_class或dispatch_set_target_queue方法设置队列的优先级
- (void)customQueueClass{
    //dipatch_queue_attr_make_with_qos_class
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, -1);
    dispatch_queue_t queue = dispatch_queue_create("com.starming.gcddemo.qosqueue", attr);
    
    //dispatch_set_target_queue
    dispatch_queue_t queue = dispatch_queue_create("com.starming.gcddemo.settargetqueue",NULL); //需要设置优先级的queue
    dispatch_queue_t referQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0); //参考优先级
    dispatch_set_target_queue(queue, referQueue); //设置queue和referQueue的优先级一样
}

// 线程通讯
- (void)downloadImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2136538-bd0196029563d498.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSData* data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:data];
        
        NSLog(@"download ---> %@", [NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"更新UI ---> %@", [NSThread currentThread]);
        });
    });
}

#pragma mark ------------------------ GCD常用函数 ------------------

#pragma mark -  延迟执行
- (void)delay
{
    /**
     *  @param DISPATCH_TIME_NOW 从现在开始的计算时间
     *  @param int64_t           延时时间，时间单位：纳秒
     *
     */
//    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        // 执行的代码
        NSLog(@"GCD ---> %@", [NSThread currentThread]);
    });
}

#pragma mark - dispatch_after延后执行
// dispatch_after只是延时提交block，不是延时立刻执行
- (void)after
{
    /*
     第一个参数为DISPATCH_TIME_NOW表示当前。第二个参数的delta表示纳秒，一秒对应的纳秒为1000000000，系统提供了一些宏来简化
     
     #define NSEC_PER_SEC 1000000000ull //每秒有多少纳秒
     #define USEC_PER_SEC 1000000ull    //每秒有多少毫秒
     #define NSEC_PER_USEC 1000ull      //每毫秒有多少纳秒
     这样如果要表示一秒就可以这样写
     
     dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
     dispatch_time(DISPATCH_TIME_NOW, 1000 * USEC_PER_SEC);
     dispatch_time(DISPATCH_TIME_NOW, USEC_PER_SEC * NSEC_PER_USEC);
     */
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self bar];
    });
}

#pragma mark -  一次性执行
- (void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"--------- once -----------");
    });
}

#pragma mark -  栅栏函数：控制队列中的任务的执行顺序
/*
 dispatch_barrier_async使用Barrier Task方法Dispatch Barrier解决多线程并发读写同一个资源发生死锁
 Dispatch Barrier确保提交的闭包是指定队列中在特定时段唯一在执行的一个。
 在所有先于Dispatch Barrier的任务都完成的情况下这个闭包才开始执行。
 轮到这个闭包时barrier会执行这个闭包并且确保队列在此过程不会执行其它任务。闭包完成后队列恢复。
 需要注意dispatch_barrier_async只在自己创建的队列上有这种作用，在全局并发队列和串行队列上，效果和dispatch_sync一样
 */
- (void)fence
{
    // 栅栏函数不能使用全局办法队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("MYQUEUE", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@" --------- start ----------- ");
    dispatch_async(queue, ^{
        NSLog(@"action01 --> %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"action02 --> %@",[NSThread currentThread]);
        
    });
    
    // 栅栏函数，上面两个先执行
    dispatch_barrier_sync(queue, ^{
        NSLog(@" --------- 栅栏函数 ----------- ");
    });
    dispatch_async(queue, ^{
        NSLog(@"action03 --> %@",[NSThread currentThread]);
    });
    NSLog(@" --------- end ----------- ");
    /*
     2016-11-26 12:11:14.085 GCD实践[7104:295024]  --------- start -----------
     2016-11-26 12:11:14.086 GCD实践[7104:295344] action01 --> <NSThread: 0x60000026ca40>{number = 3, name = (null)}
     2016-11-26 12:11:14.086 GCD实践[7104:296118] action02 --> <NSThread: 0x608000269a40>{number = 4, name = (null)}
     2016-11-26 12:11:14.086 GCD实践[7104:295024]  --------- 栅栏函数 -----------
     2016-11-26 12:11:14.087 GCD实践[7104:295024]  --------- end -----------
     2016-11-26 12:11:14.087 GCD实践[7104:296118] action03 --> <NSThread: 0x608000269a40>{number = 4, name = (null)}
     */
}

- (void)dispatchBarrierAsyncDemo {
    //防止文件读写冲突，可以创建一个串行队列，操作都在这个队列中进行，没有更新数据读用并行，写用串行。
    dispatch_queue_t dataQueue = dispatch_queue_create("com.starming.gcddemo.dataqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(dataQueue, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"read data 1");
    });
    dispatch_async(dataQueue, ^{
        NSLog(@"read data 2");
    });
    //等待前面的都完成，在执行barrier后面的
    dispatch_barrier_async(dataQueue, ^{
        NSLog(@"write data 1");
        [NSThread sleepForTimeInterval:1];
    });
    dispatch_async(dataQueue, ^{
        [NSThread sleepForTimeInterval:1.f];
        NSLog(@"read data 3");
    });
    dispatch_async(dataQueue, ^{
        NSLog(@"read data 4");
    });
}

#pragma mark -  快速迭代：开启主线程和子线程一起执行，任务是并发的
- (void)iterate
{
    // 普通遍历：同步执行
//    for (int i = 0; i < 10; i ++) {
//        NSLog(@"%zd,%@",i, [NSThread currentThread]);
//    }
    
    /**
     *  快速迭代
     *  @param 10 遍历次数
     *  @param queue  必须是并发队列
     *  @param index  index索引
     */
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        
        NSLog(@"%zd, %@",index, [NSThread currentThread]);
    });
    /* 打印结果
     2016-09-09 10:03:40.425 GCD实践[32665:693649] 1, <NSThread: 0x7ff118e09140>{number = 2, name = (null)}
     2016-09-09 10:03:40.425 GCD实践[32665:693516] 0, <NSThread: 0x7ff118d05dc0>{number = 1, name = main}
     2016-09-09 10:03:40.425 GCD实践[32665:693643] 2, <NSThread: 0x7ff118e07fc0>{number = 3, name = (null)}
     2016-09-09 10:03:40.425 GCD实践[32665:693646] 3, <NSThread: 0x7ff118c03700>{number = 4, name = (null)}
     2016-09-09 10:03:40.426 GCD实践[32665:693516] 4, <NSThread: 0x7ff118d05dc0>{number = 1, name = main}
     2016-09-09 10:03:40.426 GCD实践[32665:693649] 5, <NSThread: 0x7ff118e09140>{number = 2, name = (null)}
     2016-09-09 10:03:40.426 GCD实践[32665:693516] 8, <NSThread: 0x7ff118d05dc0>{number = 1, name = main}
     2016-09-09 10:03:40.426 GCD实践[32665:693643] 6, <NSThread: 0x7ff118e07fc0>{number = 3, name = (null)}
     2016-09-09 10:03:40.426 GCD实践[32665:693646] 7, <NSThread: 0x7ff118c03700>{number = 4, name = (null)}
     2016-09-09 10:03:40.426 GCD实践[32665:693649] 9, <NSThread: 0x7ff118e09140>{number = 2, name = (null)}
     */
}

//create dispatch block
- (void)dispatchCreateBlockDemo {
    //normal way
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"run block");
    });
    dispatch_async(concurrentQueue, block);
    
    //QOS way
    dispatch_block_t qosBlock = dispatch_block_create_with_qos_class(0, QOS_CLASS_USER_INITIATED, -1, ^{
        NSLog(@"run qos block");
    });
    dispatch_async(concurrentQueue, qosBlock);
}

//dispatch_block_wait
- (void)dispatchBlockWaitDemo {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"star");
        [NSThread sleepForTimeInterval:5.f];
        NSLog(@"end");
    });
    dispatch_async(serialQueue, block);
    //设置DISPATCH_TIME_FOREVER会一直等到前面任务都完成
    dispatch_block_wait(block, DISPATCH_TIME_FOREVER);
    NSLog(@"ok, now can go on");
}

//dispatch_block_notify
- (void)dispatchBlockNotifyDemo {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t firstBlock = dispatch_block_create(0, ^{
        NSLog(@"first block start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"first block end");
    });
    dispatch_async(serialQueue, firstBlock);
    dispatch_block_t secondBlock = dispatch_block_create(0, ^{
        NSLog(@"second block run");
    });
    //first block执行完才在serial queue中执行second block
    dispatch_block_notify(firstBlock, serialQueue, secondBlock);
}

//dispatch_block_cancel(iOS8+)
- (void)dispatchBlockCancelDemo {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t firstBlock = dispatch_block_create(0, ^{
        NSLog(@"first block start");
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"first block end");
    });
    dispatch_block_t secondBlock = dispatch_block_create(0, ^{
        NSLog(@"second block run");
    });
    dispatch_async(serialQueue, firstBlock);
    dispatch_async(serialQueue, secondBlock);
    //取消secondBlock
    dispatch_block_cancel(secondBlock);
}

#pragma mark -  队列组
- (void)queueGroup
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"编号1 --- %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"编号2 --- %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"编号3 --- %@", [NSThread currentThread]);
    });
    
    // 拦截通知，当队列组中所有任务执行完毕后 进入该方法
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---------dispatch_group_notify--------");
    });
    
    /* 打印结果
     2016-09-09 10:26:16.692 GCD实践[33455:711376] 编号2 --- <NSThread: 0x7f834b415510>{number = 3, name = (null)}
     2016-09-09 10:26:16.691 GCD实践[33455:711372] 编号1 --- <NSThread: 0x7f834b70e550>{number = 2, name = (null)}
     2016-09-09 10:26:16.692 GCD实践[33455:711377] 编号3 --- <NSThread: 0x7f834b70e6f0>{number = 4, name = (null)}
     2016-09-09 10:26:16.692 GCD实践[33455:711377] ---------dispatch_group_notify--------
     */
}

#pragma mark - dispatch_group_wait
- (void)dispatchGroupWaitDemo {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    //在group中添加队列的block
    dispatch_group_async(group, concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2.f];
        NSLog(@"1");
    });
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"2");
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"can continue");
}

#pragma mark - 队列组: 以前的写法
- (void)queueGroup2
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 在该方法后面的异步任务会被纳入到队列组的监听范围，进入群组
    // dispatch_group_enter 与 dispatch_group_leave必须配对使用
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"编号1 --- %@", [NSThread currentThread]);
        // 离开群组
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"编号2 --- %@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    // 拦截通知，当队列组中所有任务执行完毕后 进入该方法
    // 该方法异步的，不是阻塞的
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---------dispatch_group_notify--------");
    });
    
    // 和dispatch_group_notify作用相似
    // 是阻塞的
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"---------- end --------");
    
    /**
     2016-09-09 10:38:27.407 GCD实践[33968:724166] ---------- end --------
     2016-09-09 10:38:27.407 GCD实践[33968:724421] 编号1 --- <NSThread: 0x7fe988d165b0>{number = 2, name = (null)}
     2016-09-09 10:38:27.407 GCD实践[33968:724411] 编号2 --- <NSThread: 0x7fe988c13c50>{number = 3, name = (null)}
     2016-09-09 10:38:27.407 GCD实践[33968:724411] ---------dispatch_group_notify--------
     */
}

#pragma mark - 合并图片的demo
- (void)groupDemo
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    // 1. 下载第一张图片
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载第一张图片 ---> %@", [NSThread currentThread]);
        NSURL* url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2136538-bd0196029563d498.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSData* data = [NSData dataWithContentsOfURL:url];
        _image01 = [UIImage imageWithData:data];
    });
    // 2. 下载第二张图片
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载第二张图片 ---> %@", [NSThread currentThread]);
        NSURL* url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2136538-bd0196029563d498.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSData* data = [NSData dataWithContentsOfURL:url];
        _image02 = [UIImage imageWithData:data];
    });
    
    // 3. 合并图片
    dispatch_group_notify(group, queue, ^{
        NSLog(@"合并图片 ---> %@", [NSThread currentThread]);
        UIGraphicsBeginImageContext(CGSizeMake(200, 400));
        [_image01 drawInRect:CGRectMake(0, 0, 200, 200)];
        [_image02 drawInRect:CGRectMake(0, 200, 200, 200)];
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _image01 = nil;
        _image02 = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = im;
            NSLog(@"更新UI ---> %@", [NSThread currentThread]);
        });
    });
}



#pragma mark - 信号量
/*上面有可能出现的问题：第三步操作(合并图片操作)有可能比要第一步或第二步操作快一些：
    其实这个道理很简单，我们开启的网络请求，是一个异步线程，所谓的异步线程，就是告诉系统你不要管我是否完成了，你尽管执行其他操作，开一个线程让我到外面操作去执行就行了，所以我们傻 
    傻的  dispatch_group_async 自然就不会管网络操作是否完成，是否有数据了，直接执行下面操作，告诉 dispatch_group_notify 它已经完成就行了
 */

// 解决办法就是：多线程的信号量 dispatch_semaphore_t
// ` dispatch_semaphore_t` ：通俗的说我们可以理解成他是一个红绿灯的信号，当它的信号量为0时(红灯)等待，当信号量为1或大于1时(绿灯)走。
/*
 创建一个信号，value：信号量
 dispatch_semaphore_create(<#long value#>)
 使某个信号的信号量+1
 dispatch_semaphore_signal(<#dispatch_semaphore_t dsema#>)
 某个信号进行等待， timeout：等待时间，永远等待为 DISPATCH_TIME_FOREVER
 dispatch_semaphore_wait(<#dispatch_semaphore_t dsema#>, <#dispatch_time_t timeout#>)
 */

- (void)semaphoreTest
{
    // 设置一个异步线程组
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        // 设置一个网络请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.github.com"]];
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"第一步操作");
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯),此时网络请求完成返回数据，才继续执行下一个请求或操作
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        // 以下还要进行一些其他的耗时操作
        NSLog(@"耗时操作继续进行");
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        // 设置一个网络请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.github.com"]];
        // 创建一个信号量为0的信号(红灯)
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"第二步操作");
            // 使信号的信号量+1，这里的信号量本来为0，+1信号量为1(绿灯),此时网络请求完成返回数据，才继续执行下一个请求或操作
            dispatch_semaphore_signal(sema);
        }];
        [task resume];
        // 以下还要进行一些其他的耗时操作
        NSLog(@"耗时操作继续进行");
        // 开启信号等待，设置等待时间为永久，直到信号的信号量大于等于1（绿灯）
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    /*
     当线程执行到 dispatch_semaphore_wait 的时候如果网络请求还没有完成，那么信号就会继续等待，这个异步线程组就不会执行完毕。直到上网络请求完成使信号量+1,线程解除阻塞
     2016-11-26 12:18:07.051 GCD实践[7185:300394] 耗时操作继续进行
     2016-11-26 12:18:07.051 GCD实践[7185:300381] 耗时操作继续进行
     2016-11-26 12:18:09.761 GCD实践[7185:300507] 第一步操作
     2016-11-26 12:18:10.837 GCD实践[7185:300507] 第二步操作
     */
}

/*
 * 发动态的实现，有多张图片和文字，先将这多张图上传到服务器并返回图片对应的url，然后再把这些图片url和文字作为动态的属性发布到服务器，如何利用GCD来提高效率
 */
- (void)enterAndLeaveGroup{
    // imageURLs
    NSMutableArray *imageURLs= [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();                    // 1
    for (UIImage *image in images) {
        dispatch_group_enter(group);                                    // 2
//        sendPhoto(image, success:^(NSString *url) {  // 这里开始上传图片操作
//            [imageURLs addObject:url];                // 上传图片完成
            dispatch_group_leave(group);                                 // 3
//        });
    }
    dispatch_group_notify(group, dispatch_get_global_queue(), ^{         // 4
        // 最后再把这些图片url和文字上传到服务器
//        postFeed(imageURLs, text);
    });
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


// 补充: 与之前是一样的，只不过调用方式不一样
- (void)supplyTest
{
    /**
     * dispatch_queue_t queue: 队列
     * void *context: 参数
     * dispatch_function_t work: 要调用的函数名称
     */
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
}

void task(void* param){
    NSLog(@"%s", __func__);
}

#pragma mark - 单例模式的实现
- (void)singleTest
{
    SingleTool* single1 = [SingleTool shareInstance];
    SingleTool* single2 = [SingleTool shareInstance];
    SingleTool* single3 = [SingleTool shareInstance];
    
    NSLog(@"\n single1 = %@ \n single2 = %@ \n single3 = %@ \n ", single1, single2, single3);
    /**
     single1 = <SingleTool: 0x7fa9205a0010>
     single2 = <SingleTool: 0x7fa9205a0010>
     single3 = <SingleTool: 0x7fa9205a0010>
     */
}

#pragma mark - dispatch source directory demo
- (void)dispatchSourceDirectoryDemo {
    NSURL *directoryURL; // assume this is set to a directory
    int const fd = open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
        char buffer[80];
        strerror_r(errno, buffer, sizeof(buffer));
        NSLog(@"Unable to open \"%@\": %s (%d)", [directoryURL path], buffer, errno);
        return;
    }
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
                                                      DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^(){
        unsigned long const data = dispatch_source_get_data(source);
        if (data & DISPATCH_VNODE_WRITE) {
            NSLog(@"The directory changed.");
        }
        if (data & DISPATCH_VNODE_DELETE) {
            NSLog(@"The directory has been deleted.");
        }
    });
    dispatch_source_set_cancel_handler(source, ^(){
        close(fd);
    });
    dispatch_resume(source);
    //还要注意需要用DISPATCH_VNODE_DELETE 去检查监视的文件或文件夹是否被删除，如果删除了就停止监听
}

#pragma mark - dispatch source timer demo
- (void)dispatchSourceTimerDemo {
    //NSTimer在主线程的runloop里会在runloop切换其它模式时停止，这时就需要手动在子线程开启一个模式为NSRunLoopCommonModes的runloop，如果不想开启一个新的runloop可以用不跟runloop关联的dispatch source timer
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^(){
        NSLog(@"Time flies.");
    });
    dispatch_source_set_timer(source, DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC,100ull * NSEC_PER_MSEC);
    dispatch_resume(source);
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

#pragma mark - GCD实际使用
// FMDB如何使用dispatch_queue_set_specific和dispatch_get_specific来防止死锁

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;
//检查是否是同一个队列来避免死锁的方法
- (void)inDatabase:(void (^)(FMDatabase *db))block {
    //创建串行队列，所有数据库的操作都在这个队列里
    dispatch_queue_t _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
    //标记队列
    dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    FMDatabaseQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    assert(currentSyncQueue != self && "inDatabase: was called reentrantly on the same queue, which would lead to a deadlock");
}

@end


/* 几个概念：
 串行队列：在队列中，采用先进先出（FIFO）的方式从RunLoop取出任务
 并行队行：同样，在并行队列当中，依然也是采用先进先出(FIFO)的方式从RunLoop取出来
 
 异步执行：不会阻塞当前线程
 同步执行：会阻塞当前线程，直到当前的block任务执行完毕
 
 小结
 1、同步和异步决定了是否开启新的线程。main队列除外，在main队列中，同步或者异步执行都会阻塞当线的main线程，且不会另开线程。当然，永远不要使用sync向主队列中添加任务，这样子会线程卡死，具体原因看main线程。
 2、串行和并行，决定了任务是否同时执行。
 
 
 主队列（main queue）,四种通用调度队列，自己定制的队列。四种通用调度队列为
 QOS_CLASS_USER_INTERACTIVE：user interactive等级表示任务需要被立即执行提供好的体验，用来更新UI，响应事件等。这个等级最好保持小规模。
 QOS_CLASS_USER_INITIATED：user initiated等级表示任务由UI发起异步执行。适用场景是需要及时结果同时又可以继续交互的时候。
 QOS_CLASS_UTILITY：utility等级表示需要长时间运行的任务，伴有用户可见进度指示器。经常会用来做计算，I/O，网络，持续的数据填充等任务。这个任务节能。
 QOS_CLASS_BACKGROUND：background等级表示用户不会察觉的任务，使用它来处理预加载，或者不需要用户交互和对时间不敏感的任务。

 何时使用何种队列类型
 主队列（顺序）：队列中有任务完成需要更新UI时，dispatch_after在这种类型中使用。
 并发队列：用来执行与UI无关的后台任务，dispatch_sync放在这里，方便等待任务完成进行后续处理或和dispatch barrier同步。dispatch groups放在这里也不错。
 自定义顺序队列：顺序执行后台任务并追踪它时。这样做同时只有一个任务在执行可以防止资源竞争。dipatch barriers解决读写锁问题的放在这里处理。dispatch groups也是放在这里。
 
 GCD和NSOperationQueue的区别：
 1.GCD是底层的C语言构成的API，而NSOperationQueue及相关对象是Objc的对象。在GCD中，在队列中执行的是由block构成的任务，这是一个轻量级的数据结构；而Operation作为一个对象，为我们提供了更多的选择；
 2.在NSOperationQueue中，我们可以随时取消已经设定要准备执行的任务(当然，已经开始的任务就无法阻止了)，而GCD没法停止已经加入queue的block(其实是有的，但需要许多复杂的代码)；
 3.NSOperation能够方便地设置依赖关系，我们可以让一个Operation依赖于另一个Operation，这样的话尽管两个Operation处于同一个并行队列中，但前者会直到后者执行完毕后再执行；
 4.我们能将KVO应用在NSOperation中，可以监听一个Operation是否完成或取消，这样子能比GCD更加有效地掌控我们执行的后台任务；
 5.在NSOperation中，我们能够设置NSOperation的priority优先级，能够使同一个并行队列中的任务区分先后地执行，而在GCD中，我们只能区分不同任务队列的优先级，如果要区分block任务的优先级，也需要大量的复杂代码；
 6.我们能够对NSOperation进行继承，在这之上添加成员变量与成员方法，提高整个代码的复用度，这比简单地将block任务排入执行队列更有自由度，能够在其之上添加更多自定制的功能。
 
 
 参考资料：
 
 iOS多线程之GCD：http://www.jianshu.com/p/456672967e75
 iOS笔记(一)GCD多线程：信号量和条件锁: https://my.oschina.net/u/2436242/blog/518318
 细说GCD（Grand Central Dispatch）如何用: http://www.jianshu.com/p/fbe6a654604c

*/







