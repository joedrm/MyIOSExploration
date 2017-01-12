//
//  ClockViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ClockViewController.h"

#define perSecA  6
#define perMinA  6
#define perHourA  30
#define perMinHourA  0.5

#define angleToRad(angle)  ((angle) / 180 * M_PI)

@interface ClockViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *clockImage;
@property (nonatomic, strong) CALayer* secL;
@property (nonatomic, strong) CALayer* minL;
@property (nonatomic, strong) CALayer* hourL;
@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupHourL];
    [self setupMinL];
    [self setupSecL];
    
    
    // 添加定时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginRun) userInfo:nil repeats:YES];
    
    [self beginRun];
}

- (void)beginRun{
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* com = [cal components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger curSec = com.second;
    NSInteger curMin = com.minute;
    NSInteger curHour = com.hour;
    
    // 计算秒钟旋转的角度
    // angle = 当前多少秒 * 每一秒旋转多少度
    CGFloat secA = curSec * perSecA;
    self.secL.transform = CATransform3DMakeRotation(angleToRad(secA), 0, 0, 1);
    
    // 计算分钟旋转的角度
    // angle = 当前多少分 * 每一分钟旋转多少度
    CGFloat minA = curMin * perMinA;
    self.minL.transform = CATransform3DMakeRotation(angleToRad(minA), 0, 0, 1);
    
    // 计算时针旋转的角度
    // angle = 当前多少小时 * 每一小时旋转多少度
    CGFloat hourA = curHour * perHourA + curMin * perMinHourA;
    self.hourL.transform = CATransform3DMakeRotation(angleToRad(hourA), 0, 0, 1);
}

// 添加秒针
- (void)setupSecL{
    
    CALayer* secL = [CALayer layer];
    secL.bounds = CGRectMake(0, 0, 1, 80);
    secL.backgroundColor = [UIColor redColor].CGColor;
    secL.anchorPoint = CGPointMake(0.5, 1); // 设置锚点
    // 设置position点为时钟图片的中心的位置
    secL.position = CGPointMake(self.clockImage.frame.size.width*0.5, self.clockImage.frame.size.height*0.5);
    [self.clockImage.layer addSublayer:secL];
    self.secL = secL;
}

// 添加分针
- (void)setupMinL{
    
    CALayer* minL = [CALayer layer];
    minL.bounds = CGRectMake(0, 0, 3, 70);
    minL.cornerRadius = 1.5;
    minL.backgroundColor = [UIColor blackColor].CGColor;
    minL.anchorPoint = CGPointMake(0.5, 1);
    minL.position = CGPointMake(self.clockImage.frame.size.width*0.5, self.clockImage.frame.size.height*0.5);
    [self.clockImage.layer addSublayer:minL];
    self.minL = minL;
}

// 添加时针
- (void)setupHourL{
    
    CALayer* hourL = [CALayer layer];
    hourL.bounds = CGRectMake(0, 0, 3, 50);
    hourL.cornerRadius = 1.5;
    hourL.backgroundColor = [UIColor blueColor].CGColor;
    hourL.anchorPoint = CGPointMake(0.5, 1);
    hourL.position = CGPointMake(self.clockImage.frame.size.width*0.5, self.clockImage.frame.size.height*0.5);
    [self.clockImage.layer addSublayer:hourL];
    self.hourL = hourL;
}

@end
