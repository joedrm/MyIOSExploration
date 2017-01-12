//
//  CAAnimationGroupVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CAAnimationGroupVC.h"

@interface CAAnimationGroupVC ()
@property (nonatomic, strong) UIView* myView;
@end

@implementation CAAnimationGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(50, 100, 80, 80);
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    self.myView = view;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CABasicAnimation* anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"position.y";
    anim1.toValue = @400;
    
    CABasicAnimation* anim2 = [CABasicAnimation animation];
    anim2.keyPath = @"transform.scale";
    anim2.toValue = @0.5;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[anim1, anim2];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 2;
    [self.myView.layer addAnimation:group forKey:nil];
}

@end
