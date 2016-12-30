//
//  SingleViewController.m
//  GCD实践
//
//  Created by fang wang on 16/12/30.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "SingleViewController.h"
#import "SingleTool.h"

@interface SingleViewController ()

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self singleTest];
}

#pragma mark - 单例模式的实现 
- (void)singleTest
{
    SingleTool* single1 = [SingleTool shareInstance];
    SingleTool* single2 = [SingleTool shareInstance];
    SingleTool* single3 = [SingleTool shareInstance];
    
    NSLog(@"\n single1 = %@ \n single2 = %@ \n single3 = %@ \n ", single1, single2, single3);
    /**
     single1 = <SingleTool: 0x7fa9205a0010>
     single2 = <SingleTool: 0x7fa9205a0010>
     single3 = <SingleTool: 0x7fa9205a0010>
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
