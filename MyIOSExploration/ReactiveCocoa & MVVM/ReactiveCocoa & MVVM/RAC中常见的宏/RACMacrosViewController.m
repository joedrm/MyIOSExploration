//
//  RACMacrosViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "RACMacrosViewController.h"

@interface RACMacrosViewController ()
@property (weak, nonatomic) IBOutlet UITextField *testField;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RACMacrosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self test1];
}

#pragma mark - RAC
- (void)test1{

    // RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定
    
    [_testField.rac_textSignal subscribeNext:^(id x) {
        
    }];
    
    // 只要文本框文字改变，就会修改label的文字
    // RAC 用来给某个对象的某个属性绑定信号，只要产生信号内容，就会把内容赋值给属性
    RAC(_label, text) = _testField.rac_textSignal;
}

#pragma mark - RACObserve
- (void)test2{

    // RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    [RACObserve(self.view, frame) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}


#pragma mark - @weakify(Obj)和@strongify(Obj)
// @weakify(Obj)和@strongify(Obj),一般两个都是配套使用,解决循环引用问题.
- (void)test3{

    
}

@end











