//
//  DisableInteractivePopVC.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "DisableInteractivePopVC.h"

@interface DisableInteractivePopVC ()

@end

@implementation DisableInteractivePopVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.rt_disableInteractivePop = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self
               action:@selector(back)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//- (UIBarButtonItem *)customBackItemWithTarget:(id)target action:(SEL)action
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [button sizeToFit];
//    [button addTarget:target
//               action:action
//     forControlEvents:UIControlEventTouchUpInside];
//    return [[UIBarButtonItem alloc] initWithCustomView:button];
//}

- (void)back{

    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
