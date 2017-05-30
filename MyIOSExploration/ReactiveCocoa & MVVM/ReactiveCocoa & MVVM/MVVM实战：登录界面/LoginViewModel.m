//
//  LoginViewModel.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/5/31.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init{

    if (self = [super init]) {
        [self setupViewModel];
    }
    return self;
}

- (void)setupViewModel{

    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd)]
                                            reduce:^id(NSString* account, NSString* pwd){
        return @(account.length && pwd.length);
    }];
    
    _loginCommond = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"发送登录请求");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [subscriber sendNext:@"请求登录的数据"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    // 处理登录请求返回的结果
    // 获取命令中的信号源
    [_loginCommond.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    // 判断信号是否执行完成，来显示和隐藏指示器
    [[_loginCommond.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
            NSLog(@"显示指示器");
        }else{
            NSLog(@"执行完成");
            NSLog(@"隐藏指示器");
        }
    }];
    
}

@end












