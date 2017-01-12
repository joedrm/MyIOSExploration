//
//  Case8ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case8ViewController.h"

@interface Case8ViewController ()

@property (nonatomic, strong) UILabel *animateLabel;
@property (nonatomic, strong) MASConstraint *centerXConstraint;
@end

@implementation Case8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"约束动画";
    
    UILabel* animateLabel = [[UILabel alloc] init];
    animateLabel.text = @"Masonry约束动画";
    animateLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:animateLabel];
    self.animateLabel = animateLabel;
    [animateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(200));
        make.height.equalTo(@(40));
        _centerXConstraint = make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setTitle:@"" forState:UIControlStateNormal];
    actionButton.backgroundColor = [UIColor redColor];
    [actionButton addTarget:self action:@selector(beginAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionButton];
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.4);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)beginAnimate{
    // 设置初始状态
    _centerXConstraint.equalTo(@(-CGRectGetWidth(self.view.frame)));
    // 立即让约束生效
    [self.view layoutIfNeeded];
    // 设置动画约束
    _centerXConstraint.equalTo(@0);
    // 动画生效
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
