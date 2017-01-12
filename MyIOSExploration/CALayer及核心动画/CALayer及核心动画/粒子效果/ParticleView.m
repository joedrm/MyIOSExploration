//
//  VCView.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ParticleView.h"

@interface ParticleView ()
@property (nonatomic, strong) UIBezierPath* path;
@property (nonatomic, strong) CALayer* dotLayer;
@end

@implementation ParticleView

+ (Class)layerClass{
    
    return [CAReplicatorLayer class];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    CALayer* dotLayer = [CALayer layer];
    dotLayer.frame = CGRectMake(0, 0, 20, 20);
    dotLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:dotLayer];
    self.dotLayer = dotLayer;
    
    // 拿到当前view的CAReplicatorLayer，设置复制数
    CAReplicatorLayer* repLayer = (CAReplicatorLayer*)self.layer;
    repLayer.instanceCount = 30;
    repLayer.instanceDelay = 0.5;
    
    // 创建路径
    UIBezierPath* path = [UIBezierPath bezierPath];
    self.path = path;
}

- (void)pan:(UIGestureRecognizer*)pan
{
    CGPoint point = [pan locationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self.path moveToPoint:point];
    }else{
        [self.path addLineToPoint:point];
        [self setNeedsDisplay];
    }
    
}

- (void)startDraw{
    CAKeyframeAnimation* keyAnim = [CAKeyframeAnimation animation];
    keyAnim.keyPath = @"position";
    keyAnim.path = self.path.CGPath;
    keyAnim.repeatCount = MAXFLOAT;
    keyAnim.duration = 3.0;
    
    [self.dotLayer addAnimation:keyAnim forKey:nil];
}

- (void)reDraw{
    // 删除动画
    [self.dotLayer removeAllAnimations];
    // 删除路径
    [self.path removeAllPoints];
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{

    [self.path stroke];
}

@end







