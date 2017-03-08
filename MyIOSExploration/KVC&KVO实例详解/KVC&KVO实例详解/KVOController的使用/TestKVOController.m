//
//  TestKVOController.m
//  KVC&KVO实例详解
//
//  Created by fang wang on 17/3/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TestKVOController.h"
#import "Fizz.h"

@interface TestKVOController ()
@property (nonatomic, strong) Fizz* fizz;
@end

@implementation TestKVOController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fizz = [[Fizz alloc] init];
    [self test1];
    self.fizz.number = @10;
}

/*
 使用 KVOController 进行键值观测可以说完美地解决了在使用原生 KVO 时遇到的各种问题。

     不需要手动移除观察者；
     实现 KVO 与事件发生处的代码上下文相同，不需要跨方法传参数；
     使用 block 来替代方法能够减少使用的复杂度，提升使用 KVO 的体验；
     每一个 keyPath 会对应一个属性，不需要在 block 中使用 if 判断 keyPath；
 
 实现原理：如何优雅地使用 KVO https://github.com/Draveness/iOS-Source-Code-Analyze/blob/master/contents/KVOController/KVOController.md
 */
- (void)test1{

    [self.KVOController observe:self.fizz keyPath:@"number" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"%@, %@", change[@"new"],change[@"old"]);
    }];
}

@end
