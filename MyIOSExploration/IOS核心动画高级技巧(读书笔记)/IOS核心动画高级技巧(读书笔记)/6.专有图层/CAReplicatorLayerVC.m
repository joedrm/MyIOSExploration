//
//  CAReplicatorLayerVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/1.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CAReplicatorLayerVC.h"

@interface CAReplicatorLayerVC ()

@end

@implementation CAReplicatorLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // CAReplicatorLayer的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。
    
    [self test1];
}

#pragma mark - 重复图层（Repeating Layers）

- (void)test1{

    CAReplicatorLayer* layer = [CAReplicatorLayer layer];
    layer.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
    layer.position = self.view.center;
    layer.instanceCount = 10;
    [self.view.layer addSublayer:layer];

    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    layer.instanceTransform = transform;
    
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    
    CALayer* subLayer = [CALayer layer];
    subLayer.frame = CGRectMake(100, 100, 100, 100);
    subLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:subLayer];
}

#pragma mark - 反射

@end






