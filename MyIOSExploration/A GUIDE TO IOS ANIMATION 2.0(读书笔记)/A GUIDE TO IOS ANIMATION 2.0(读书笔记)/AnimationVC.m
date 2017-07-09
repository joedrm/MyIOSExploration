//
//  AnimationVC.m
//  A GUIDE TO IOS ANIMATION 2.0(读书笔记)
//
//  Created by wdy on 2017/7/8.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "AnimationVC.h"

static NSInteger const kLayerNumber = 5;

//layer的宽高
static CGFloat const kLayerWidth = 160;
static CGFloat const kLayerHeight = 160;

@interface AnimationVC ()

@end

@implementation AnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    for (int i =0; i < kLayerNumber; i ++)
    {
        CALayer *layer = [CALayer layer];
        CGFloat x = 0;
        if (i%2 != 0)
        {
            x = self.view.frame.size.width / 2.0;
        }
        else
        {
            x = (self.view.frame.size.width - 2 * kLayerWidth)/2.0;
        }
        layer.frame = CGRectMake(x, 20 + i/2 * kLayerHeight, kLayerWidth, kLayerHeight);
        [self.view.layer addSublayer:layer];
        
        switch (i) {
                case 0:
            {
                [self loveAnimationLayer:layer withSize:layer.bounds.size tintColor:[UIColor brownColor]];
            }
                break;
                case 1:
            {
                [self moreBallSpinFadeAnimationLayer:layer withSize:layer.bounds.size tintColor:[UIColor purpleColor]];
            }
                break;
                case 2:
            {
                [self lineBallSpinFadeAnimationLayer:layer withSize:layer.bounds.size tintColor:[UIColor greenColor]];
            }
                break;
                case 3:
            {
                [self voiceAnimationLayer:layer withSize:layer.bounds.size tintColor:[UIColor blueColor]];
            }
                break;
                case 4:
            {
                [self ballSpinFadeAnimationLayer:layer withSize:layer.bounds.size tintColor:[UIColor orangeColor]];
            }
                break;
                
            default:
                break;
        }
    }
}



#pragma mark == private method
//爱心类型
- (void)loveAnimationLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height);
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:replicatorLayer];
    
    CALayer *lineBallLayer = [CALayer layer];
    lineBallLayer.backgroundColor = tintColor.CGColor;
    lineBallLayer.cornerRadius = 5;
    lineBallLayer.frame = CGRectMake((size.width - 10)/2.0, 20, 10, 10);
    
    
    
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointMake(size.width/2.0, 25)];
    //二次贝塞尔曲线
    [tPath addQuadCurveToPoint:CGPointMake(size.width/2.0, 100) controlPoint:CGPointMake(size.width/2.0 + 80, -10)];
    [tPath addQuadCurveToPoint:CGPointMake(size.width/2.0, 25) controlPoint:CGPointMake(size.width/2.0 - 80, -10)];
    [tPath closePath];//封闭路径
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = tPath.CGPath;//根据path路径来进行动画
    animation.duration = 8;//动画时间
    animation.repeatCount = HUGE;//一直重复动画
    [lineBallLayer addAnimation:animation forKey:@""];//key可以不设置
    
    [replicatorLayer addSublayer:lineBallLayer];
    //    replicatorLayer.instanceColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor;
    replicatorLayer.instanceGreenOffset = -0.03;       // 颜色值递减。
    replicatorLayer.instanceRedOffset = -0.02;         // 颜色值递减。
    replicatorLayer.instanceBlueOffset = -0.01;        // 颜色值递减。
    replicatorLayer.instanceCount = 40;//复制lineBallLayer 40个
    replicatorLayer.instanceDelay = 0.2;//每个复制对象执行path路径动画的时间间隔 前一个和后一个之间
}

//许多圆球无规则变大变小
- (void)moreBallSpinFadeAnimationLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height);
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:replicatorLayer];
    
    CALayer *lineBallLayer = [CALayer layer];
    lineBallLayer.backgroundColor = tintColor.CGColor;
    lineBallLayer.cornerRadius = 10;//设半径为10  则lineBallLayer为圆
    lineBallLayer.frame = CGRectMake(10, 5, 20, 20);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.2);
    animation.duration = 0.5;
    animation.autoreverses = YES;//是否安原路径返回
    animation.repeatCount = HUGE;//一直重复动画
    [lineBallLayer addAnimation:animation forKey:@""];
    [replicatorLayer addSublayer:lineBallLayer];
    
    replicatorLayer.instanceCount = 3;//复制三个
    replicatorLayer.instanceDelay = 0.3;//三个执行的时间间隔为0.3s
    replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 30, 0, 0);//对复制的对象进行向右平移30 （在前一个的基础上） 故形成图中的三个横向的圆球
    
    
    CAReplicatorLayer *verticalReplicatorLayer = [CAReplicatorLayer layer];
    verticalReplicatorLayer.frame = CGRectMake(0, 0, layer.frame.size.width, 30);
    verticalReplicatorLayer.backgroundColor = [UIColor grayColor].CGColor;
    [layer addSublayer:verticalReplicatorLayer];
    
    verticalReplicatorLayer.instanceCount = 3;
    verticalReplicatorLayer.instanceDelay = 0.3;
    verticalReplicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 30, 0);
    [verticalReplicatorLayer addSublayer:replicatorLayer];
}


//三个点有大有小的变化
- (void)lineBallSpinFadeAnimationLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height);
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:replicatorLayer];
    
    CALayer *lineBallLayer = [CALayer layer];
    lineBallLayer.backgroundColor = tintColor.CGColor;
    lineBallLayer.cornerRadius = 10;
    lineBallLayer.frame = CGRectMake(10, 40, 20, 20);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.2);
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE;
    [lineBallLayer addAnimation:animation forKey:@""];
    [replicatorLayer addSublayer:lineBallLayer];
    
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = 0.3;
    replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 30, 0, 0);
}

//一串圈圈，依次变大变小 透明度也变化
- (void)ballSpinFadeAnimationLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, layer.frame.size.width-40, layer.frame.size.height-40);
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:replicatorLayer];
    
    
    CALayer *ballLayer = [CALayer layer];
    ballLayer.frame = CGRectMake((CGRectGetWidth(replicatorLayer.frame) - 10)/2.0, 0, 10, 10);
    ballLayer.backgroundColor = tintColor.CGColor;
    ballLayer.cornerRadius = 5.0;
    
    
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0)]];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0.5),@(1.0),@(0.5)];
    
    //opacityAnimation.keyTimes
    //keyTimes这个可选参数可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 1;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.repeatCount = HUGE_VALF;
    //匀速
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.animations = @[transformAnimation,opacityAnimation];
    [ballLayer addAnimation:groupAnimation forKey:@""];
    
    //绕Z轴旋转M_PI / 10.0  下面复制20个 刚好是一圈  2*M_PI
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, M_PI / 10.0, 0, 0, 1);
    
    [replicatorLayer addSublayer:ballLayer];
    replicatorLayer.instanceCount = 20;
    replicatorLayer.instanceTransform = transform;
    replicatorLayer.instanceDelay = 0.05;
}

//音量动画效果
- (void)voiceAnimationLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor
{
    CAShapeLayer *voiceLayer = [CAShapeLayer layer];
    voiceLayer.fillColor = tintColor.CGColor;
    voiceLayer.frame = CGRectMake(10, 20, 20, layer.frame.size.height - 20);
    //position为anchorPoint的点在superlayer中的坐标 此处anchorPoint的y坐标为1 因为我们是以底部为中心进行缩放
    voiceLayer.position = CGPointMake(10 + 20 * 0.5, 20 + (layer.frame.size.height - 20)*1);
    voiceLayer.anchorPoint = CGPointMake(0.5, 1);
    
    //顶部圆角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, voiceLayer.frame.size.width, voiceLayer.frame.size.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    voiceLayer.path = path.CGPath;
    
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height);
    replicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:replicatorLayer];
    
    [replicatorLayer addSublayer:voiceLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0.1);
    animation.autoreverses = YES;
    animation.repeatCount = HUGE;
    animation.duration = 0.7;
    [voiceLayer addAnimation:animation forKey:nil];
    
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = 0.5;
    
    replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 25, 0, 0);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
