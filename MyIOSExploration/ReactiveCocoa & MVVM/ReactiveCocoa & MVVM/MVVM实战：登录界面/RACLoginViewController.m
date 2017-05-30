//
//  RACLoginViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/5/30.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "RACLoginViewController.h"
#import "LoginViewModel.h"

@interface RACLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) LoginViewModel* viewModel;
@end

@implementation RACLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
    [self loginEvent];
}

- (void)bindViewModel{
    
    // 将文本框内容改变的信号 赋值给 viewModel 的 account
    
    RAC(self.viewModel, account) = self.accountFiled.rac_textSignal;
    RAC(self.viewModel, pwd) = self.pwdFiled.rac_textSignal;
}

- (void)loginEvent{
    
    RAC(self.loginBtn, enabled) = self.viewModel.loginEnableSignal;
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.loginCommond execute:nil];
    }];
}


- (LoginViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

@end

/*
 
 2017-05-31 00:26:26.997 ReactiveCocoa & MVVM[49225:2172412] 发送登录请求
 2017-05-31 00:26:26.999 ReactiveCocoa & MVVM[49225:2172412] 正在执行
 2017-05-31 00:26:26.999 ReactiveCocoa & MVVM[49225:2172412] 显示指示器
 2017-05-31 00:26:27.574 ReactiveCocoa & MVVM[49225:2172412] 请求登录的数据
 2017-05-31 00:26:27.575 ReactiveCocoa & MVVM[49225:2172412] 执行完成
 2017-05-31 00:26:27.576 ReactiveCocoa & MVVM[49225:2172412] 隐藏指示器
 */
