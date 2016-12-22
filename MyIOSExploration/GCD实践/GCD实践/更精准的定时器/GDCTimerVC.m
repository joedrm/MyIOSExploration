//
//  GDCTimerVC.m
//  GCD实践
//
//  Created by fang wang on 16/12/22.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "GDCTimerVC.h"
#import "GCDTimer.h"

@interface GDCTimerVC ()
{
    CADisplayLink*      _displayLink;
    NSTimer*            _timer;
    dispatch_source_t   _gcdTimer;
}
@end

static NSString *myTimer = @"MyTimer";

@implementation GDCTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGCDTimer];
    
    /* 启动一个timer，每隔2秒执行一次 */
    
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething) object:nil];
//    [thread start];
    
    __weak typeof(self) weakSelf = self;
    [[GCDTimer sharedInstance] scheduledDispatchTimerWithName:myTimer timeInterval:2.0 queue:nil repeats:NO actionOption:AbandonPreviousAction action:^{
        [weakSelf doSomethingEveryTwoSeconds];
    }];
}

/* timer每次执行打印一条log记录，在执行到n==10的时候cancel掉timer */
- (void)doSomethingEveryTwoSeconds
{
    static NSUInteger n = 0;
    NSLog(@"myTimer runs %lu times!", (unsigned long)n++);
    
    if (n >= 10) {
        [[GCDTimer sharedInstance] cancelTimerWithName:myTimer];
    }
}

- (void)doSomething
{
    _timer = [NSTimer timerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doSomethingEveryTwoSeconds)
                                   userInfo:nil
                                    repeats:YES];
    [NSThread currentThread];
}

- (void)someWhereA
{
    _timer = [NSTimer timerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(doSomethingEveryTwoSeconds)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)someWhereB
{
    [_timer invalidate];
}

/* 持有timerManager的对象销毁时，将其中的timer全部撤销 */

- (void)dealloc
{
    [_timer invalidate];
}


// -----------------------------首先来看三种定时器的实现-----------------------------



/*
 CADisplayLink
 默认同屏幕的刷新率，一般屏幕的默认刷新次数为60次/s  1帧（frame）约为 1/60 秒 ，默认不会添加到当前runloop里面，需要手动添加进去.
 
 特点：CADisplayLink是一个和屏幕刷新率同步 的定时器类。CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息，CADisplayLink类对应的selector就会被调用一次，所以可以使用CADisplayLink做一些和屏幕操作相关的操作。
 
 iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。但如果调用的方法比较耗时，超过了屏幕刷新周期，就会导致跳过若干次回调调用机会。如果CPU过于繁忙，无法保证屏幕60次/秒的刷新率，就会导致跳过若干次调用回调方法的机会，跳过次数取决CPU的忙碌程度。
 */
- (void)initDisplayLink{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startTimer)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink.frameInterval = 60;
    
    // 销毁
//    [_displayLink invalidate]
//    _displayLink = nil;
}

/*
 NSTimer
 使用下面的方法会自动把timer加入MainRunloop的NSDefaultRunLoopMode中如果主线程需要操作scrollview等UI事件，则需要改变NSTimer的mode）
 特点：存在延迟 ，不管是一次性的还是周期性的timer的实际触发事件的时间，都会与所加入的RunLoop和RunLoop Mode有关，如果此RunLoop正在执行一个连续性的运算，timer就会被延时出发。重复性的timer遇到这种情况，如果延迟超过了一个周期，则会在延时结束后立刻执行，并按照之前指定的周期继续执行
 */
- (void)initTimer{

    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}


- (void)initGCDTimer{
    
    /*
     参数：
     type	dispatch源可处理的事件
     handle	可以理解为句柄、索引或id，假如要监听进程，需要传入进程的ID
     mask	可以理解为描述，提供更详细的描述，让它知道具体要监听什么
     queue	自定义源需要的一个队列，用来处理所有的响应句柄（block）
     */
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    /*
     dispatch_time_t start,是一个opaque类型，我们不能直接操作它。我们得需要 dispatch_time 和 dispatch_walltime 函数来创建它们
     uint64_t interval, 每秒执行多少次
     uint64_t leeway);  允许出现多少误差，0为最精准
     */
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1*NSEC_PER_SEC, NSEC_PER_SEC);
    
    // block内部修饰的局部变量，可以在block代码块里面改变
    __block int i = 0;
    
    // 执行事件
    dispatch_source_set_event_handler(_gcdTimer, ^{
        NSLog(@"%d", i++);
    });
    // 开始执行
    dispatch_resume(_gcdTimer);
    dispatch_cancel(_gcdTimer);
}

// 倒计时的例子
- (void)countDownDemo{
    //倒计时时间
    __block int timeout = 3;
    
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置1s触发一次，0s的误差
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    //触发的事件
    dispatch_source_set_event_handler(timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            //取消dispatch源
            dispatch_source_cancel(timer);
            
        }
        else{
            
            timeout--;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //更新主界面的操作
                
                NSLog(@"~~~~~~~~~~~~~~~~%d", timeout);
                
            });
        }
    });
    
    //开始执行dispatch源
    dispatch_resume(timer);
}


- (void)startTimer{
    
    NSLog(@"startTimer");
}

@end






