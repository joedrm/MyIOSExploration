//
//  WheelViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "MyWheelViewController.h"
#import "WheelView.h"

@interface MyWheelViewController ()
@property (nonatomic, strong) WheelView* wheelView;
@property (nonatomic, strong) UIImageView* imageV;
@end

@implementation MyWheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat Screen_Width = [UIScreen mainScreen].bounds.size.width;
    
    WheelView* wheelView = [WheelView wheelViewFromNib];
    //wheelView.frame = CGRectMake(0, 0, 286, 286);
    wheelView.center = self.view.center;
    [self.view addSubview:wheelView];
    self.wheelView = wheelView;
    
    UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setTitle:@"开始" forState:UIControlStateNormal];
    start.backgroundColor = [UIColor greenColor];
    [start addTarget:self action:@selector(startAnim) forControlEvents:UIControlEventTouchUpInside];
    start.frame = CGRectMake(30, 100, 60, 30);
    [self.view addSubview:start];
    
    UIButton* stop = [UIButton buttonWithType:UIButtonTypeCustom];
    [stop setTitle:@"暂停" forState:UIControlStateNormal];
    stop.backgroundColor = [UIColor redColor];
    [stop addTarget:self action:@selector(stopAnim) forControlEvents:UIControlEventTouchUpInside];
    stop.frame = CGRectMake(200, 100, 60, 30);
    [self.view addSubview:stop];
    
    UIImageView* imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(120, 100, 50, 50);
    imageV.image = [UIImage imageNamed:@"name.jpeg"];
    [self.view addSubview:imageV];
    self.imageV = imageV;
    
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginTest)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)beginTest{
    
    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, M_PI / 300.0);
}

- (void)startAnim{

    [self.wheelView startRotation];
}

- (void)stopAnim{

    [self.wheelView stop];
}

@end
