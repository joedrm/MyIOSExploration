//
//  HeartBeatEffectVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "HeartBeatEffectVC.h"

@interface HeartBeatEffectVC ()
@property (nonatomic, strong) UIImageView* heartView;
@end

@implementation HeartBeatEffectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* heartView = [[UIImageView alloc] init];
    heartView.image = [UIImage imageNamed:@"心"];
    heartView.frame = CGRectMake(0, 0, 200, 200);
    heartView.center = self.view.center;
    [self.view addSubview:heartView];
    self.heartView = heartView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CABasicAnimation* anim = [CABasicAnimation animation];
    
    // 设置属性
    anim.keyPath = @"transform.scale";
    anim.toValue = @0;
    
    // 设置动画的执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 设置动画执行的时长
    anim.duration = 1;
    // 自动反转，（怎么去，就怎么回来）
    anim.autoreverses = YES;
    [self.heartView.layer addAnimation:anim forKey:nil];
}

@end
