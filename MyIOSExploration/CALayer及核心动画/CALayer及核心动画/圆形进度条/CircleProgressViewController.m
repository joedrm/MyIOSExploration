//
//  CircleProgressViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2017/11/26.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CircleProgressViewController.h"
#import "CircleProgressView.h"

@interface CircleProgressViewController ()
{
    float _progress;
}
@property (nonatomic, strong) CircleProgressView* progressView;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation CircleProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progress = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CircleProgressView* progressView = [[CircleProgressView alloc] init];
    progressView.frame = CGRectMake(10, 100, 200, 200);
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    UISlider* slider = [[UISlider alloc] init];
    slider.frame = CGRectMake(10, CGRectGetMaxY(progressView.frame) + 20, 300, 10);
    [slider addTarget:self action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(loading) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)loading{
    NSLog(@"loading...");
    
    _progress += (0.00166667);
    if (_progress >= 1) {
        NSLog(@"_progress = %@", @(_progress));
        [_timer invalidate];
        _timer = nil;
    }
    
    [self.progressView drawProgress:_progress];
}

- (void)progressChange:(UISlider *)sender{
    NSLog(@"sender.value = %@", @(sender.value));
    [self.progressView drawProgress:sender.value];
}

@end

/*
 参考：
 http://www.brighttj.com/ios/ios-implement-loop-progress.html
 
 */





