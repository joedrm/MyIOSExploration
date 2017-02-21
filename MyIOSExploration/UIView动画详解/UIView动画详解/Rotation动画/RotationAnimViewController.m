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
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = self.squreView.transform;
        self.squreView.transform = CGAffineTransformRotate(transform, M_PI);
    } completion:^(BOOL finished) {
       [self rotateAnim];
    }];
    
}


@end
