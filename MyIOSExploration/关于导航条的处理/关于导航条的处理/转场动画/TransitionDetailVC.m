//
//  TransitionDetailVC.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TransitionDetailVC.h"

@interface TransitionDetailVC ()

@end

@implementation TransitionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView* imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageV.image = [UIImage imageNamed:@"test.jpg"];
    [self.view addSubview:imageV];
    imageV.center = self.view.center;
    self.itemImageView = imageV;
}


@end
