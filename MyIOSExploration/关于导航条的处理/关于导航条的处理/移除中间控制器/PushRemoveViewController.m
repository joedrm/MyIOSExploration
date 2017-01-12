//
//  PushRemoveViewController.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PushRemoveViewController.h"
#import "DisableInteractivePopVC.h"
@interface PushRemoveViewController ()

@end

@implementation PushRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)push{
    
    [self.rt_navigationController pushViewController:[[DisableInteractivePopVC alloc] init]
                                            animated:YES
                                            complete:^(BOOL finished) {
                                                [self.rt_navigationController removeViewController:self];
                                            }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
