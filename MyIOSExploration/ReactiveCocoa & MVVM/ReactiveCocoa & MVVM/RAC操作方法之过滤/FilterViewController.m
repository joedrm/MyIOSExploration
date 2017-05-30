//
//  FilterViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/5/30.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}


#pragma mark - skip
- (void)skip{

    // skip: 跳跃几个值
    // 表示输入第一次，不会被监听到，跳过第一次发出的信号
    [[self.textFiled.rac_textSignal skip:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}


#pragma mark - distinctUntilChanged
- (void)distinctUntilChanged{

    // distinctUntilChanged 当前的值和上一个值相同，就不会被订阅到
    RACSubject *subject = [RACSubject subject];
    
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"1"];
}

#pragma mark - takeUntil
- (void)takeUntil{

    // 1、创建信号
    RACSubject *subject = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    // 只要传入的 信号 发送完成 或者 发送任意数据，就不会再接受源信号的内容
    [[subject takeUntil:signal] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    [signal sendNext:@"1"];
    [signal sendNext:@1];
    
    // signal 发送完成，就不会 再接受源信号（subject）的内容
//    [signal sendCompleted];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];
    
}

#pragma mark - takeLast
// 取最后几个值
// 取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
- (void)takeLast{

    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendCompleted];
}


#pragma mark - take
- (void)take{

    // take : 从开始一共取N次的信号,取前面的几个值
    
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}


#pragma mark - ignore
- (void)ignore{

    // ignore 忽略一些值
    RACSubject* subject = [RACSubject subject];
    
    // ignoreValues 忽略所有值
    RACSignal* ignoreSignal = [subject ignore:@"1"];
    
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [subject sendNext:@"1"];
    
}


#pragma mark - filter
- (void)filter{
    // 目的：只有文本框的内容长度 >5 时，才想要获取文本框的内容
    [[_textFiled.rac_textSignal filter:^BOOL(id value) {
        
        return [value length] > 5;
        
        // 返回值，就是过滤条件，只有满足这个条件，才能获取到内容
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
}


@end
