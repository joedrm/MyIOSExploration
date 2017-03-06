//
//  SignalOperateViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "SignalOperateViewController.h"
#import <ReactiveCocoa/RACReturnSignal.h>

@interface SignalOperateViewController ()

@end

@implementation SignalOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindSignal];
    
}

- (void)bindSignal{

    RACSubject* subject = [RACSubject subject];
    
    RACSignal* bindSignal = [subject bind:^RACStreamBindBlock{
       
        return ^RACSignal *(id value, BOOL *stop){
        
            NSLog(@"接收到原信号的内容 = %@", value);
            
            NSString* str = [NSString stringWithFormat:@"hello: %@",value];
            return [RACReturnSignal return:str];
        };
    }];

    [bindSignal subscribeNext:^(id x) {
        
        NSLog(@"接收到绑定信号处理完的信号 = %@", x);
        
    }];
    [subject sendNext:@"123"];
}



@end
