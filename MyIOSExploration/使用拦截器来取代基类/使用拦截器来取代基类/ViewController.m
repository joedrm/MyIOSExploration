//
//  ViewController.m
//  使用拦截器来取代基类
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "UIViewController+Interceptor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)test
{
    TestViewController* testVC = [[TestViewController alloc] init];
    testVC.disabledInterceptor = YES;
    [self.navigationController pushViewController:testVC animated:YES];
}
/*
 参考文章：
 http://www.jianshu.com/p/61d2b86512ad
 https://github.com/wujunyang/MobileProject/blob/master/MobileProject/Resource/AppDelegate/XAspect-GeTuiAppDelegate.m  拦截器的使用
 */
@end
