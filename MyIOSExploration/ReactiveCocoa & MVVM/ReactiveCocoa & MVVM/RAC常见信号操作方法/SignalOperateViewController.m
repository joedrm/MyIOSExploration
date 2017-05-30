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
    
    [self zipWith];
    
}

// 底层bind的实现
- (void)bindSignal{

    // 创建信号
    RACSubject* subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal* bindSignal = [subject bind:^RACStreamBindBlock{
       
        return ^RACSignal *(id value, BOOL *stop){
        
            NSLog(@"接收到原信号的内容 = %@", value);
            
            NSString* str = [NSString stringWithFormat:@"hello: %@",value];
            return [RACReturnSignal return:str];
        };
    }];

    // 订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        
        NSLog(@"接收到绑定信号处理完的信号 = %@", x);
        
    }];
    [subject sendNext:@"123"];
}


- (void)flattenMap{

    // 创建信号
    RACSubject* subject = [RACSubject subject];
    
    // 绑定信号
    RACSignal* bindSignal = [subject flattenMap:^RACStream *(id value) {
       
        value = [NSString stringWithFormat:@"hello:%@", value];
        return [RACReturnSignal return:value];
    }];
    
    /*---------------
    也就是说：flattenMap 方法里面的 block 返回的是什么信号，订阅的就是什么信号
    ---------------*/
    
    // 订阅信号
    [bindSignal subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
    
    // 发送数据
    [subject sendNext:@"123"];
    
    /** 打印结果：
     2017-05-30 20:51:42.144 ReactiveCocoa & MVVM[45734:2035744] hello:123
     */
}


- (void)map{

    // 创建信号
    RACSubject* subject = [RACSubject subject];
    
    RACSignal* signal = [subject map:^id(id value) {
     
        // 返回的类型就是你需要映射的值
        return [NSString stringWithFormat:@"hello:%@", value];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [subject sendNext:@"111"];
    [subject sendNext:@"222"];
    
    /** 打印结果：
     2017-05-30 20:57:12.025 ReactiveCocoa & MVVM[45986:2040826] hello:111
     2017-05-30 20:57:12.025 ReactiveCocoa & MVVM[45986:2040826] hello:222
     */
}

/*---------------
    flattenMap : 一般用于信号中的信号
    map：用于普通的信号
 ---------------*/

// 实现方法一
- (void)flattenMapDemo1{

    RACSubject* signalOfSignals = [RACSubject subject];
    RACSubject* suject = [RACSubject subject];
    
    [signalOfSignals subscribeNext:^(RACSubject* suject) {
        [suject subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
    }];
    
    [signalOfSignals sendNext:suject];
    [suject sendNext:@"123"];
    
    // 2017-05-30 21:02:17.993 ReactiveCocoa & MVVM[46119:2044527] 123
}

// 实现方法二
- (void)flattenMapDemo2{
    
    RACSubject* signalOfSignals = [RACSubject subject];
    RACSubject* suject = [RACSubject subject];
    
    [[signalOfSignals flattenMap:^RACStream *(id value) {
        return value;
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [signalOfSignals sendNext:suject];
    [suject sendNext:@"123"];
    
}

#pragma mark - 信号组合：concat
- (void)concat{

    RACSignal* signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求 1");
        
        [subscriber sendNext:@"数据 1"];
        // 注意：第一个信号必须要调用 sendCompleted，否则后面的信号不会来
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal* signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求 2");
        
        [subscriber sendNext:@"数据 2"];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    // 按顺序去连接，先发送请求 signal1 。再发送 signal2
    RACSignal* concatSignal = [signal1 concat:signal2];
    
    [concatSignal subscribeNext:^(id x) {
        // 既能拿到 signal1的值， 又能拿到 signal2的值
        NSLog(@"%@", x);
    }];
    /*
     2017-05-30 21:16:25.955 ReactiveCocoa & MVVM[46356:2054980] 发送请求 1
     2017-05-30 21:16:25.955 ReactiveCocoa & MVVM[46356:2054980] 数据 1
     2017-05-30 21:16:25.956 ReactiveCocoa & MVVM[46356:2054980] 发送请求 2
     2017-05-30 21:16:25.956 ReactiveCocoa & MVVM[46356:2054980] 数据 2
     */
}


#pragma mark - 信号组合: then
- (void)then{
    
    RACSignal* signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求 1");
        [subscriber sendNext:@"数据 1"];
        // 注意：第一个信号必须要调用 sendCompleted，否则后面的信号不会来
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal* signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送请求 2");
        [subscriber sendNext:@"数据 2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // then: 会忽略第一个信号的所有值
    RACSignal* thenSignal = [signal1 then:^RACSignal *{
        // 返回的信号就是需要组合的信号
        return signal2;
    }];
    
    [thenSignal subscribeNext:^(id x) {
        // 既能拿到 signal1的值， 又能拿到 signal2的值
        NSLog(@"%@", x);
    }];
    /*
     2017-05-30 21:22:30.070 ReactiveCocoa & MVVM[46518:2059864] 发送请求 1
     2017-05-30 21:22:30.071 ReactiveCocoa & MVVM[46518:2059864] 发送请求 2
     2017-05-30 21:22:30.071 ReactiveCocoa & MVVM[46518:2059864] 数据 2
     */
}

#pragma mark - 合并信号: merge
/*
 merge : 是没有顺序的
 */
- (void)merge{

    RACSubject* signalA = [RACSubject subject];
    RACSubject* signalB = [RACSubject subject];
    
    RACSignal* mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
       
        NSLog(@"%@", x);
    }];
    
    [signalB sendNext:@"下部分"];
    [signalA sendNext:@"上部分"];
}


#pragma mark - 压缩信号: zipWith
// 把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
// zipWith 夫妻关系
- (void)zipWith{
    
    RACSubject* signalA = [RACSubject subject];
    RACSubject* signalB = [RACSubject subject];
    
    // 压缩成一个信号
    // zipWith ： 当一个界面有多个请求的时候，要等所有的请求完成才能更新 UI
    // 等所有的信号发送内容的时候才会调用
    RACSignal* zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
    
    [signalA sendNext:@"123"];
    [signalB sendNext:@"456"];
    
    /*
     2017-05-30 21:50:57.681 ReactiveCocoa & MVVM[46979:2079341] <RACTuple: 0x60800001d860> (
        123,
        456
     )
     */
}


- (void)combineLatest{

    
}
@end




































