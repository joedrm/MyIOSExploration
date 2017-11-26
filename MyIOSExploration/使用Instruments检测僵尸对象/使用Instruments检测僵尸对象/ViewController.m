//
//  ViewController.m
//  使用Instruments检测僵尸对象
//
//  Created by wdy on 2017/8/19.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __unsafe_unretained NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:@"1"];
    
    
    
    
    UIView* testView = [UIView new];
    testView.layer.shadowOpacity = 0.25;
    testView.layer.shadowRadius = 4;
    testView.layer.shadowOffset = CGSizeMake(0, 0);
    // 加上这句代码，设置阴影路径，提高性能
    testView.layer.shadowPath = [UIBezierPath bezierPathWithRect:testView.bounds].CGPath;
    /*
     原来设置了阴影之后Core Animation必须要先做一幕动画确定视图具体形状之后才能渲染阴影，这是非常费事的操作。
     如果我们提前设置好阴影路径，那么 iOS 就不需要总是计算如何绘制阴影，而是用已经计算好的路径，那就会极大的提高性能。
     */
}

@end
