//
//  LayoutAnimateViewController.m
//  AutoLayoutPractice
//
//  Created by wdy on 2017/3/19.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LayoutAnimateViewController.h"

@interface LayoutAnimateViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidthConstrain;

@end

@implementation LayoutAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /* 关于约束动画可以参考这两篇文章：
     http://sindrilin.com/animate/2016/03/19/Layout%E5%8A%A8%E7%94%BB%E7%9A%84%E6%9B%B4%E5%A4%9A%E4%BD%BF%E7%94%A8
     http://sindrilin.com/animate/2016/02/28/Layout%E5%8A%A8%E7%94%BB%E5%88%9D%E4%BD%93%E9%AA%8C
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.redViewWidthConstrain.constant = 100;
    [UIView animateWithDuration:1 animations:^{
        // 强制刷新
        [self.view layoutIfNeeded];
    }];
}

@end
