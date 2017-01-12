//
//  CABasicAnimationVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CABasicAnimationVC.h"

@interface CABasicAnimationVC ()
@property (nonatomic, strong) UIView* redView;
@end

@implementation CABasicAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView* redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.frame = CGRectMake(10, 200, 100, 100);
    [self.view addSubview:redView];
    self.redView = redView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    // 创建动画对象（设置layer的属性值。）
    CABasicAnimation* anim = [CABasicAnimation animation];
    
    // 设置属性值
    anim.keyPath = @"position.x";
    anim.toValue = @300;
    
    // 动画完成时，自动删除动画
    anim.removedOnCompletion = NO;
    // 动画完成时的恢复状态：
    // kCAFillModeBackwards: 最后面的状态
    // kCAFillModeForwards: 最前面的状态
    anim.fillMode = kCAFillModeForwards;
    // 也可以这样写
//    anim.fillMode = @"backwards";
    
    [self.redView.layer addAnimation:anim forKey:nil];
}


@end
