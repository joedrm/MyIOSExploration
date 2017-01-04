//
//  CustomNavigationBarVC.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CustomNavigationBarVC.h"
#import "CustomNavigationBar.h"

@interface CustomNavigationBarVC ()

@end

@implementation CustomNavigationBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = self.view.tintColor;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.view.tintColor};
}

- (Class)rt_navigationBarClass{
    
    return [CustomNavigationBar class];
}


@end
