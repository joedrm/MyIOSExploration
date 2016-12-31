//
//  ViewController.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"IOS核心动画高级技巧(读书笔记)";
    self.titleArr = @[@"2.寄宿图",
                      @"3.图层几何学",
                      @"4.视觉效果",
                      @"5.变换",
                      @"6.专有图层"];
    
    self.vcArr = @[@"BoardViewLayerVC",
                   @"LayerGeometryVC",
                   @"VisualEffectVC",
                   @"TransformVC",
                   @"ProperLayerViewController"
                   ];
}


@end
