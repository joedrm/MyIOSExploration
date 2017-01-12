//
//  Case3ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case3ViewController.h"

#define screen_width [UIScreen mainScreen].bounds.size.width


@interface Case3ViewController ()
@property (nonatomic, strong) MASConstraint *maxWidth;
@end

@implementation Case3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百分比宽度";
    self.view.backgroundColor = [UIColor whiteColor];

    // 容器View
    UIView* containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(screen_width*0.1);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        _maxWidth = make.width.mas_equalTo(screen_width*0.8);
        make.height.mas_equalTo(60);
    }];

    // 子View
    UIView* sonView = [[UIView alloc] init];
    sonView.backgroundColor = [UIColor redColor];
    [containerView addSubview:sonView];
    [sonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(containerView);
        make.width.equalTo(containerView.mas_width).multipliedBy(0.5);
    }];
    
    // 调整宽度的slider
    UISlider* slider = [[UISlider alloc] init];
    [slider setValue:1.0];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(modifyContainerViewWidth:) forControlEvents:UIControlEventValueChanged];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(screen_width*0.8);
    }];
}

- (void)modifyContainerViewWidth:(UISlider *)sender {
    if (sender.value) {
        _maxWidth.mas_equalTo(sender.value*screen_width*0.8);
    }
}


@end





