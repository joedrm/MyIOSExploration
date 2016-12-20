//
//  WheelViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "WheelViewController.h"
#import "WheelView.h"

@interface WheelViewController ()
@property (nonatomic, strong) WheelView* wheelView;
@end

@implementation WheelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WheelView* wheelView = [WheelView wheelView];
    wheelView.center = self.view.center;
    [self.view addSubview:wheelView];
    self.wheelView = wheelView;
    
}



@end
