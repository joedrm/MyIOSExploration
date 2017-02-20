//
//  ViewController.m
//  转场动画
//
//  Created by wdy on 2016/10/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ViewController.h"
#import "TransitionTestVC.h"
#import "UIViewController+KMNavigationBarTransition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 80, 40)];
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
}

- (void)clicked:(UIButton *)sender
{
    [self.navigationController pushViewController:[[TransitionTestVC alloc] init] animated:YES];
}

@end


/*
 https://github.com/seedante/iOS-Note/wiki/ViewController-Transition  视图控制器转场详解
 https://github.com/STShenZhaoliang/STNavigationBar   一个全面的UINavigationBar的使用,各种效果
 
 https://github.com/NewAmsterdamLabs/ZOZolaZoomTransition  一个放大转场动画
 */
