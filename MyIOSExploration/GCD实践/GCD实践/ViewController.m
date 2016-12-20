//
//  ViewController.m
//  GCD实践
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"
#import "SingleTool.h"

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

// ------------------------ GCD常用函数 ------------------

// 延迟执行
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

// 栅栏函数：控制队列中的任务的执行顺序
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

// 快速迭代：开启主线程和子线程一起执行，任务是并发的
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

// 队列组
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

// 队列组: 以前的写法
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

// 合并图片的demo
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


// 条件锁: 条件锁可以控制线程的执行次序，相当于NSOperation中的依赖关系

- (void)lockTest{
    /*     
     常见的锁：
     1.@synchronized(对象) 对象锁
     2.NSLock 互斥锁
     3.NSConditionLock 条件锁
     4.NSRecursiveLock 递归锁
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

// 单例模式的实现
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
@end


/* 几个概念：
 串行队列：在队列中，采用先进先出（FIFO）的方式从RunLoop取出任务
 并行队行：同样，在并行队列当中，依然也是采用先进先出(FIFO)的方式从RunLoop取出来
 
 异步执行：不会阻塞当前线程
 同步执行：会阻塞当前线程，直到当前的block任务执行完毕
 
 小结
 1、同步和异步决定了是否开启新的线程。main队列除外，在main队列中，同步或者异步执行都会阻塞当线的main线程，且不会另开线程。当然，永远不要使用sync向主队列中添加任务，这样子会线程卡死，具体原因看main线程。
 2、串行和并行，决定了任务是否同时执行。
 
 参考资料：
 
 iOS多线程之GCD：http://www.jianshu.com/p/456672967e75
 iOS笔记(一)GCD多线程：信号量和条件锁: https://my.oschina.net/u/2436242/blog/518318
 */

/*
 GCD和NSOperationQueue的区别：
 
 1.GCD是底层的C语言构成的API，而NSOperationQueue及相关对象是Objc的对象。在GCD中，在队列中执行的是由block构成的任务，这是一个轻量级的数据结构；而Operation作为一个对象，为我们提供了更多的选择；
 2.在NSOperationQueue中，我们可以随时取消已经设定要准备执行的任务(当然，已经开始的任务就无法阻止了)，而GCD没法停止已经加入queue的block(其实是有的，但需要许多复杂的代码)；
 3.NSOperation能够方便地设置依赖关系，我们可以让一个Operation依赖于另一个Operation，这样的话尽管两个Operation处于同一个并行队列中，但前者会直到后者执行完毕后再执行；
 4.我们能将KVO应用在NSOperation中，可以监听一个Operation是否完成或取消，这样子能比GCD更加有效地掌控我们执行的后台任务；
 5.在NSOperation中，我们能够设置NSOperation的priority优先级，能够使同一个并行队列中的任务区分先后地执行，而在GCD中，我们只能区分不同任务队列的优先级，如果要区分block任务的优先级，也需要大量的复杂代码；
 6.我们能够对NSOperation进行继承，在这之上添加成员变量与成员方法，提高整个代码的复用度，这比简单地将block任务排入执行队列更有自由度，能够在其之上添加更多自定制的功能。

*/







