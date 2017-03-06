//
//  CommonApplyViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CommonApplyViewController.h"
#import "GreenView.h"
#import <ReactiveCocoa/NSObject+RACKVOWrapper.h>


@interface CommonApplyViewController ()
@property (weak, nonatomic) IBOutlet GreenView *greenV;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *testFiled;

@end

@implementation CommonApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self mutiRequestTest];
}

#pragma mark - 代替代理
- (void)delegateTest{
    
    // 此处缺点是不能传值,
    // 传值的话还是 RACSubject
    [[self.greenV rac_signalForSelector:@selector(clicked:)] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了...");
    }];
}

#pragma mark - 代替KVO
- (void)KVOTest{
    
    // 第一种写法：需要导入头文件 #import <ReactiveCocoa/NSObject+RACKVOWrapper.h>
    [self.greenV rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"%@, %@", value, change);
    }];
    
    // 第二种写法
    [[self.greenV rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"x = %@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.greenV.frame = CGRectMake(0, 64, 200, 200);
}

#pragma mark - 监听事件点击
- (void)touchEventTest{

    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮点击了。。。");
    }];
}

#pragma mark - 代替通知

- (void)notiTest{

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - 监听文本框

- (void)textFiledTest{

    [[_testFiled rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}


#pragma mark - 处理当界面有多次请求时，需要都获取到数据时，才能展示界面

- (void)mutiRequestTest{
    
    RACSignal* signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"第一个请求的数据"];
        
        return nil;
    }];
    
    RACSignal* signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"第二个请求的数据"];
        
        return nil;
    }];
    
    // 当数组中所有的信号都发送数据的时候，才会调用 @selector
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(reuqestEndAndUpdateUIWith:data2:) withSignals:signal1, signal2, nil];
}

- (void)reuqestEndAndUpdateUIWith:(NSString *)str1 data2:(NSString *)str2{
    
    NSLog(@"str1 = %@, str2 = %@", str1, str2);
}
@end


















