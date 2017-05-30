//
//  BasicSimpleViewController.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "BasicSimpleViewController.h"
#import "DelegateTestView.h"
#import "TestModel.h"

@interface BasicSimpleViewController ()
@property (nonatomic, weak) id <RACSubscriber> subscriber;
@end

@implementation BasicSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self test9];
}


#pragma mark - RACSingle 使用步骤：
- (void)test1{
    
    // 1. 创建信号（冷信号）
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {  // didSubscribe
        
        // didSubscribe 这里的Block，只要信号被订阅了就会调用
        // didSubscribe 作用，就是发送数据
        NSLog(@"信号被订阅了");
        
        _subscriber = subscriber; // 保存订阅者
        
        // 3. 发送数据
        [subscriber sendNext:@1];
        return [RACDisposable disposableWithBlock:^{
            // 只要信号被取消就会开这里
            // 用于清空资源
            // 默认一个信号发送数据完毕就会主动取消订阅，
            // 但是只要订阅者在，就不会在这里自动取消信号订阅，需要手动取消 [disposable dispose];
            NSLog(@"信号被取消订阅了");
        }];
    }];
    
    // 2. 订阅信号(热信号)
    RACDisposable* disposable =  [signal subscribeNext:^(id x) {  // nextBlock
        
        // nextBlock 这里的Block，只要订阅者发送数据就会调用
        // nextBlock 作用，就是处理数据，显示在UI上面
        
        NSLog(@"%@", x);
    }];
    
    // 取消订阅信号
    [disposable dispose];
    
    // 小结：
    /*
     1. 只要订阅者调用了 sendNext，就会执行 nextBlock
     2. 只要信号被订阅，就会执行 didSubscribe
     3. 前提条件是 RACDynamicSignal，不同类型的订阅，处理订阅的事情就不一样
     
     RACSiganl: 信号类,一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
     信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
     默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
     调用信号RACSignal的subscribeNext就能订阅
     
     RACSubscriber: 表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。
     通过create创建的信号，都有一个订阅者，帮助他发送数据。
     
     RACDisposable： 用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
     使用场景:不想监听某个信号时，可以通过它主动取消订阅信号。 RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
     使用场景:通常用来代替代理，有了它，就不必要定义代理了。
     */
}



#pragma mark - RACSubject: 信号提供者，自己可以充当信号，又能发送信号。
// 使用场景: 通常用来代替代理，有了它，就不必要定义代理了。
- (void)test2{

    // 创建信号
    RACSubject* subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id x) {
        
        NSLog(@"订阅者一接受到数据：%@", x);
    }];
    
    [subject subscribeNext:^(id x) {
        
        NSLog(@"订阅者二接受到数据：%@", x);
    }];
    
    // 发送信号
    [subject sendNext:@1];
    // 底层实现：遍历所有的订阅者，调用 nextBlock
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
}



#pragma mark - RACReplaySubject: 重复提供信号类，RACSubject 的子类。
/*
RACReplaySubject 与 RACSubject 区别:
RACReplaySubject 可以先发送信号，再订阅信号，RACSubject 就不可以。
使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
使用场景二:可以设置 capacity 数量来限制缓存的 value 的数量,即只缓充最新的几个值。
 */
- (void)test3{
    
    // 创建信号
    RACReplaySubject* replaySubject = [RACReplaySubject subject];
    
    // 先发送信号
    [replaySubject sendNext:@1];
    
    // 再订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"接受到数据：%@", x);
    }]; // 这里会去遍历所有的值，拿到当前的订阅者去发送数据
    
    // RACReplaySubject: 底层实现和 RACSubject 不一样。
    // 1.调用 sendNext 发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用 subscribeNext 订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
}

#pragma mark - RACSubject 代替代理
- (void)test4{

    DelegateTestView* testView = [[DelegateTestView alloc] init];
    testView.frame = CGRectMake(50, 100, 200, 200);
    testView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:testView];
    [testView.btnSubject subscribeNext:^(id x) {
        NSLog(@"接受到数据：%@", x);
    }];
}


#pragma mark - RACTuple 元组类,类似NSArray,用来包装值.
- (void)test5{

    RACTuple* tuple = [RACTuple tupleWithObjectsFromArray:@[@"a", @"b", @1]];
    NSLog(@"%@", tuple[1]);
}



#pragma mark - RACSequence
// RACSequence: RAC 中的集合类，用于代替 NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
- (void)test6{

#warning 遍历数组
    NSArray* arr = @[@"a", @"b", @1];
    
    RACSequence* sequence = arr.rac_sequence;
    
    RACSignal* signal = sequence.signal;
    
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 快捷写法
    // // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
#warning 遍历字典，遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary* dict = @{@"name": @"小米", @"age": @"22", @"address": @"上海"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple* x) {
        
//        NSString* key = x[0];
//        NSString* value = x[1];
        
        // 也可以这样写：
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key, NSString *value) = x;
        
        NSLog(@"%@ - %@", key, value);
    }];
}


#pragma mark - 字典转模型
- (void)test7{

    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil];
    NSArray* arr = [NSArray arrayWithContentsOfFile:filePath];
    
//    NSMutableArray* modelArr;
//    [arr.rac_sequence.signal subscribeNext:^(NSDictionary* x) {
//        TestModel* model = [TestModel modelWithDict:x];
//        [modelArr addObject:model];
//    }];
    
    // 高级用法
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray* resultArr = [[arr.rac_sequence map:^id(NSDictionary* value) {
        
        return [TestModel modelWithDict:value];
    }] array];
    
    NSLog(@"resultArr = %@", resultArr);
}


#pragma mark - RACMulticastConnection
// RACMulticastConnection 用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理
- (void)test8{

    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
    
    // 不管订阅多少次，只会请求一次
    // RACMulticastConnection 使用时，必须要有信号
    
    // 1 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSLog(@"发送请求");
        [subscriber sendNext:@"数据来了"];
        return nil;
    }];
    
    // 2 把信号转换成连接类
    // 确定源信号的订阅者，即 RACSubject
    // 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
    RACMulticastConnection* connection = [signal publish];
    
    // 3 订阅连接类中的信号
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者1：%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者2：%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者3：%@",x);
    }];
    
    // 4 连接
    [connection connect];
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
}


#pragma mark - RACCommand
// RACCommand: RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
// 使用场景:监听按钮点击，网络请求
- (void)test9{

    // 1 创建命令
    RACCommand* command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        // input 执行命令传入的参数
        // 这里的 Block 执行的时候就会调用
        NSLog(@"input = %@", input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 拿到执行命令中产生的数据
    
// 第一种方式
//    RACSignal* signal = [command execute:@1];// 2 执行命令
//    [signal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    
    // 第二种方式
    // executionSignals 信号源，信号中的信号，信号发送的数据就是一个信号
    // 注意：必须在执行命令前订阅
//    [command.executionSignals subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//        RACSignal* signal = (RACSignal *)x;
//        [signal subscribeNext:^(id x) {
//            NSLog(@"%@",x); // 这里才是真正的拿到的数据
//        }];
//    }];
    
    // 5.executing 监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
//    [[command.executing skip:1] subscribeNext:^(id x) {
//        if ([x boolValue]) {
//            // 正在执行
//            NSLog(@"正在执行");
//        }else{
//            // 执行完成
//            NSLog(@"执行完成");
//        }
//    }];

    // 第三种写法，开发中最常用
    // switchToLatest 获取最新发送的信号，只能用于信号中的信号
    // switchToLatest: 用于signal of signals，获取 signal of signals 发出的最新信号,也就是可以直接拿到 RACCommand 中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [command execute:@1];
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
}


// 模拟使用 switchToLatest
- (void)test10{

    RACSubject* signalOfSignals = [RACSubject subject];
    RACSubject* signalA = [RACSubject subject];
//    RACSubject* signalB = [RACSubject subject];
    
    // 获取信号中的最新信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"订阅到了数据：%@", x);
    }];
    
    [signalOfSignals sendNext:signalA];
    [signalA sendNext:@1];
    
    /* 打印结果：
     
     2017-05-30 15:54:13.589 ReactiveCocoa & MVVM[40404:1908681] 订阅到了数据：1
     */
}

@end









