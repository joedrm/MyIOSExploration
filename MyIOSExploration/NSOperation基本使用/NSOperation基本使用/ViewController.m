//
//  ViewController.m
//  NSOperation基本使用
//
//  Created by wangdongyang on 16/9/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 https://github.com/Qiyun2014/YNSerialOperation  队列任务按顺序执行
 
 */

#import "ViewController.h"
#import "CustomOperation.h"

@interface ViewController ()
{
    UIImage* _image01;
    UIImage* _image02;
}
@property (nonatomic, strong) NSOperationQueue* queue;
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
    [self combineImage];
}

// 合并图片的Demo
- (void)combineImage
{
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 ---> %@", [NSThread currentThread]);
        NSURL* url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2136538-bd0196029563d498.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSData* data = [NSData dataWithContentsOfURL:url];
        _image01 = [UIImage imageWithData:data];
    }];
    
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 ---> %@", [NSThread currentThread]);
        NSURL* url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2136538-bd0196029563d498.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSData* data = [NSData dataWithContentsOfURL:url];
        _image02 = [UIImage imageWithData:data];
    }];
    
    // 合并图片
    NSBlockOperation* combineImage = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"合并图片 ---> %@", [NSThread currentThread]);
        UIGraphicsBeginImageContext(CGSizeMake(200, 400));
        [_image01 drawInRect:CGRectMake(0, 0, 200, 200)];
        [_image02 drawInRect:CGRectMake(0, 200, 200, 200)];
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _image01 = nil;
        _image02 = nil;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = im;
            NSLog(@"更新UI ---> %@", [NSThread currentThread]);
        }];
    }];
    
    // 注意：设置依赖关系
    [combineImage addDependency:op1];
    [combineImage addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:combineImage];
}

// 线程间通讯
- (void)threadConnection
{
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 ---> %@", [NSThread currentThread]);
        NSURL* url = [NSURL URLWithString:@"http://upload-images.jianshu.io/upload_images/2136538-bd0196029563d498.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
        NSData* data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:data];
        
        // 更新UI: [NSOperationQueue mainQueue]
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新UI ---> %@", [NSThread currentThread]);
            self.imageView.image = image;
        }];
    }];
    [queue addOperation:op1];
    /**
     2016-09-09 15:53:15.789 NSOperation基本使用[42226:909130] 下载图片 ---> <NSThread: 0x7fa228d02130>{number = 2, name = (null)}
     2016-09-09 15:53:15.879 NSOperation基本使用[42226:908913] 更新UI ---> <NSThread: 0x7fa228e044e0>{number = 1, name = main}
     */
}

// 操作依赖和监听
- (void)listener
{
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
//    NSOperationQueue* queue2 = [[NSOperationQueue alloc] init];
    
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ---- %@", [NSThread currentThread]);
    }];
    
    // 操作监听:
    op3.completionBlock = ^{
        NSLog(@"任务 3 执行完成了 ---- %@", [NSThread currentThread]);
    };
    
    // 操作依赖
    [op1 addDependency:op2];
    [op2 addDependency:op3];
    // 不能循环依赖, 可以跨队列依赖
//    [op3 addDependency:op1];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
//    [queue2 addOperation:op3];
    /**
     2016-09-09 15:40:31.701 NSOperation基本使用[41730:896414] 3 ---- <NSThread: 0x7fd2e3538120>{number = 2, name = (null)}
     2016-09-09 15:40:31.702 NSOperation基本使用[41730:896401] 2 ---- <NSThread: 0x7fd2e34080e0>{number = 3, name = (null)}
     2016-09-09 15:40:31.702 NSOperation基本使用[41730:896401] 1 ---- <NSThread: 0x7fd2e34080e0>{number = 3, name = (null)}
     */
}

// 开始、暂停、继续、取消
- (void)operationAction
{
    // 只会针对opertaion有效，对opertaion里面正在执行的任务是无效
    // 自定义的Operation执行 暂停、继续、取消没有作用，
    [self.queue setSuspended:NO];//暂停
    [self.queue setSuspended:YES];//继续
    [self.queue cancelAllOperations];//取消
}

// 设置最大并发数
- (void)maxOperationCount
{
    self.queue = [[NSOperationQueue alloc] init];
    
    // 同一时间最多有多少个操作可以执行
    // maxConcurrentOperationCount > 1 为并发队列；== 1为串行队列 == 0不执行任务 == -1最大值，不受限制
    self.queue.maxConcurrentOperationCount = 3;
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op6 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op7 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op8 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ---- %@", [NSThread currentThread]);
    }];
    
    [self.queue addOperation:op1];
    [self.queue addOperation:op2];
    [self.queue addOperation:op3];
    [self.queue addOperation:op4];
    [self.queue addOperation:op5];
    [self.queue addOperation:op6];
    [self.queue addOperation:op7];
    [self.queue addOperation:op8];
    /** 只开三条线程
     2016-09-09 15:10:34.818 NSOperation基本使用[40663:873665] 2 ---- <NSThread: 0x7f9ea342b310>{number = 2, name = (null)}
     2016-09-09 15:10:34.818 NSOperation基本使用[40663:873666] 3 ---- <NSThread: 0x7f9ea37080f0>{number = 3, name = (null)}
     2016-09-09 15:10:34.818 NSOperation基本使用[40663:873467] 1 ---- <NSThread: 0x7f9ea351d800>{number = 4, name = (null)}
     2016-09-09 15:10:34.819 NSOperation基本使用[40663:873666] 1 ---- <NSThread: 0x7f9ea37080f0>{number = 3, name = (null)}
     2016-09-09 15:10:34.819 NSOperation基本使用[40663:873665] 2 ---- <NSThread: 0x7f9ea342b310>{number = 2, name = (null)}
     2016-09-09 15:10:34.820 NSOperation基本使用[40663:873467] 3 ---- <NSThread: 0x7f9ea351d800>{number = 4, name = (null)}
     2016-09-09 15:10:34.820 NSOperation基本使用[40663:873666] 3 ---- <NSThread: 0x7f9ea37080f0>{number = 3, name = (null)}
     2016-09-09 15:10:34.820 NSOperation基本使用[40663:873665] 2 ---- <NSThread: 0x7f9ea342b310>{number = 2, name = (null)}
     */
}

// 自定义operation
// 好处：有利于代码的封装和复用，
- (void)customOperation
{
    CustomOperation* op1 = [[CustomOperation alloc] init];
    CustomOperation* op2 = [[CustomOperation alloc] init];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];

    [queue addOperation:op1];
    [queue addOperation:op2];
    /**
     2016-09-09 15:00:40.395 NSOperation基本使用[40261:865638] <NSThread: 0x7fead3c28ba0>{number = 2, name = (null)}
     2016-09-09 15:00:40.395 NSOperation基本使用[40261:865612] <NSThread: 0x7fead3d07580>{number = 3, name = (null)}
     */
}

// NSBlockOperation
- (void)blockOperationWithQueue
{
    // 1.1 创建操作，封装任务
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2 ---- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation* op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3 ---- %@", [NSThread currentThread]);
    }];
    
    // 1.2 给op1追加操作
    [op1 addExecutionBlock:^{
        NSLog(@"4 ---- %@", [NSThread currentThread]);
    }];
    
    [op1 addExecutionBlock:^{
        NSLog(@"5 ---- %@", [NSThread currentThread]);
    }];
    
    // 2. 创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    // 3. 添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    /**
     2016-09-09 14:55:47.362 NSOperation基本使用[40053:861700] 4 ---- <NSThread: 0x7fb813ca61b0>{number = 5, name = (null)}
     2016-09-09 14:55:47.362 NSOperation基本使用[40053:861661] 2 ---- <NSThread: 0x7fb813d2e480>{number = 2, name = (null)}
     2016-09-09 14:55:47.362 NSOperation基本使用[40053:861701] 5 ---- <NSThread: 0x7fb813c9f000>{number = 6, name = (null)}
     2016-09-09 14:55:47.362 NSOperation基本使用[40053:861646] 1 ---- <NSThread: 0x7fb813f042b0>{number = 4, name = (null)}
     2016-09-09 14:55:47.362 NSOperation基本使用[40053:861655] 3 ---- <NSThread: 0x7fb813e03cf0>{number = 3, name = (null)}
     */
}

// NSInvocationOperation
- (void)invocationOperationWithQueue
{
    // 1. 创建操作，封装任务
    NSInvocationOperation* op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation* op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
    NSInvocationOperation* op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download3) object:nil];
    
    // 2. 创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    // 3. 添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    /** 异步办法执行
     *
     2016-09-09 14:48:56.242 NSOperation基本使用[39776:855634] download2 - <NSThread: 0x7fc290f96cf0>{number = 3, name = (null)}
     2016-09-09 14:48:56.242 NSOperation基本使用[39776:855640] download1 - <NSThread: 0x7fc290d13e90>{number = 4, name = (null)}
     2016-09-09 14:48:56.242 NSOperation基本使用[39776:855646] download3 - <NSThread: 0x7fc290f96810>{number = 2, name = (null)}
     *
     */
}

- (void)download1
{
    NSLog(@"download1 - %@", [NSThread currentThread]);
}

- (void)download2
{
    NSLog(@"download2 - %@", [NSThread currentThread]);
}

- (void)download3
{
    NSLog(@"download3 - %@", [NSThread currentThread]);
}

@end
