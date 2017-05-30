//
//  CombineViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/5/30.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CombineViewController.h"

@interface CombineViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdFiled;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation CombineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 组合
    /**
     (id<NSFastEnumeration>) : 组合哪些信号
     reduce : 聚合
     reduce中的block简介:
        reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
        reduceblcok的返回值：聚合信号之后的内容。
     */
//    RACSignal* combineSignal = [RACSignal combineLatest:@[self.accountFiled.rac_textSignal, self.pwdFiled.rac_textSignal] reduce:^id{
//        // 聚合的值就是组合信号的内容
//        // 只要源信号发送内容就会调用，组合一个新的值（也就是说，只要文本框内容法师改变了就会调用）
//        
//        return @"123";
//    }];
    

    // reduce 的参数必须和组合信号一一对应
    RACSignal* combineSignal = [RACSignal combineLatest:@[
                                                            self.accountFiled.rac_textSignal,
                                                            self.pwdFiled.rac_textSignal
                                                           ]
                                                 reduce:^id( NSString* account, NSString* pwd)
    {
        NSLog(@"%@ ---- %@", account, pwd);
        
        return @(account.length && pwd.length);
    }];
    
//    [combineSignal subscribeNext:^(id x) {
//        
//        self.loginBtn.enabled = [x boolValue];
//        
//    }];
    // 更简单的写法
    RAC(self.loginBtn, enabled) = combineSignal;
}

- (IBAction)login:(UIButton *)sender {
    
}

@end
