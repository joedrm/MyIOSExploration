//
//  VoiceShakeViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "VoiceShakeViewController.h"

@interface VoiceShakeViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation VoiceShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加复制层
    CAReplicatorLayer* repLayer = [CAReplicatorLayer layer];
    repLayer.frame = self.contentV.bounds;
    [self.contentV.layer addSublayer:repLayer];
    
    // 复制子层的个数
    repLayer.instanceCount = 5;
    // 子层做偏移操作
    repLayer.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    repLayer.instanceDelay = 1;
    
    CALayer* layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.frame = CGRectMake(0, 0, 30, 100);
    layer.anchorPoint = CGPointMake(0, 1);
    layer.position = CGPointMake(0, self.contentV.bounds.size.height);
    [repLayer addSublayer:layer];
    
    
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.toValue = @0;
    anim.keyPath = @"transform.scale.y";
    anim.repeatCount = MAXFLOAT;
    anim.autoreverses = YES;
    anim.duration = 1.0;
    [layer addAnimation:anim forKey:nil];
}


@end
