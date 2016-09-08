//
//  ViewController.m
//  GCD实践
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
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
    [self delay];
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

// ------ GCD常用函数   

//延迟执行
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

// 一次性执行
- (void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"--------- once -----------");
    });
}

@end












