//
//  CAKeyframeAnimationVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/19.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CAKeyframeAnimationVC.h"


#define angleToRad(angle)  ((angle) / 180 * M_PI)

@interface CAKeyframeAnimationVC ()
@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation CAKeyframeAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"name.jpeg"];
    imageView.frame = CGRectMake(0, 0, 200, 150);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self fun2];
}


// 通过路径来实现帧动画
- (void)fun2{
    
    CAKeyframeAnimation* keyframeAnim = [CAKeyframeAnimation animation];
    
    keyframeAnim.duration = 2.0f;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(300, 50)];
    [path addLineToPoint:CGPointMake(300, 400)];
    
    keyframeAnim.keyPath = @"position";
    keyframeAnim.path = path.CGPath;
    
    [self.imageView.layer addAnimation:keyframeAnim forKey:nil];
}


// 通过values数组来实现帧动画
- (void)fun1{

    CAKeyframeAnimation* keyframeAnim = [CAKeyframeAnimation animation];
    
    keyframeAnim.keyPath = @"transform.rotation";
    keyframeAnim.values = @[@(angleToRad(-3)), @(angleToRad(3)), @(angleToRad(-3))];
    
    keyframeAnim.repeatCount = MAXFLOAT;
    keyframeAnim.duration = 0.5;
    
    [self.imageView.layer addAnimation:keyframeAnim forKey:nil];
}

@end
