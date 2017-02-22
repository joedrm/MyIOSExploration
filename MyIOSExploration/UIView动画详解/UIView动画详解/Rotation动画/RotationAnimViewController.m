//
//  RotationAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//


#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

#import "RotationAnimViewController.h"

@interface RotationAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *squreView;

@end

@implementation RotationAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rotateAnim];
    
}

- (void)rotateAnim{
    
    
    //参考： https://github.com/ruddfawcett/RFRotate  可以很方便地对任意基于UIView的视图进行旋转，可以自定义旋转的角度以及旋转时间
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = self.squreView.transform;
        self.squreView.transform = CGAffineTransformRotate(transform, M_PI);
    } completion:^(BOOL finished) {
       [self rotateAnim];
    }];
    
}


@end
