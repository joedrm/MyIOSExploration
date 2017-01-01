//
//  CAGradientLayerVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/1.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CAGradientLayerVC.h"

@interface CAGradientLayerVC ()

@end

@implementation CAGradientLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self test1];
    [self test2];
}

#pragma mark - 基本使用

- (void)test1{
    // startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}
    CAGradientLayer* layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, kScreenWidth*0.6, kScreenWidth*0.6);
    layer.position = CGPointMake(self.view.centerX, self.view.centerY - 120);
    [self.view.layer addSublayer:layer];
    
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                     (__bridge id)[UIColor blueColor].CGColor,
                     (__bridge id)[UIColor blackColor].CGColor];
    
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
}

#pragma mark - 多重渐变
- (void)test2{

    CAGradientLayer* layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, kScreenWidth*0.6, kScreenWidth*0.6);
    layer.position = CGPointMake(self.view.centerX, self.view.centerY + 120);
    [self.view.layer addSublayer:layer];
    
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                     (__bridge id)[UIColor blueColor].CGColor,
                     (__bridge id)[UIColor blackColor].CGColor];
    
    layer.locations = @[@0.0, @0.2, @0.7];
    
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
}

@end
