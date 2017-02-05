//
//  MainViewController.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"IOS核心动画高级技巧(读书笔记)";
    self.titleArr = @[
                      @"ModalContentViewController",
                      @"Toast"
                      ];
    
    
    self.vcArr = @[
                   @"MultiCustomUIComponentVC",
                   @"TestToastViewController"
                   ];
}

@end


/*
 参考资料：
 https://github.com/qcl901028/CustomView
 
 */
