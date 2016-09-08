//
//  BaseNavigationController.m
//  UITableViewHeader各种效果
//
//  Created by wangdongyang on 16/9/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}
@end
