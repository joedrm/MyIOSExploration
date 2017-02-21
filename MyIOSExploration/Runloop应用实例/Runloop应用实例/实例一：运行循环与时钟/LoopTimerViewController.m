//
//  LoopTimerViewController.m
//  Runloop应用实例
//
//  Created by fang wang on 17/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LoopTimerViewController.h"

@interface LoopTimerViewController ()
@property(nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) CFRunLoopRef cfLoop;
@end

@implementation LoopTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self initTimer];
    [self initThread];
}

- (void)initTimer{

    NSTimer* timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)startTimer{

    static int num = 0;
    ///  耗时操作
    for (int i = 0; i < 1000 * 1000; ++i) {
        [NSString stringWithFormat:@"耗时操作 - %d", i];
    }
    NSLog(@"%d", num++);
}

// ----------------------------------- 上面代码 运行测试，会发现卡顿非常严重 ------------------------



// 优化代码

- (void)initThread{
    // 将时钟添加到其他线程工作
    NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(startLoopTimer) object:nil];
    [thread start];
}

- (void)startLoopTimer{
    
    @autoreleasepool {
        NSTimer* timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        _cfLoop = CFRunLoopGetCurrent();
        // 主线程的运行循环是默认启动的，但是子线程的运行循环是默认不工作的，这样能够保证线程执行完毕后，自动被销毁
        CFRunLoopRun();
    }
}

// 停止运行循环
- (void)stopTimer{
    
    if (_cfLoop == NULL) {
        return;
    }
    
    CFRunLoopStop(_cfLoop);
    _cfLoop = NULL;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

@end
