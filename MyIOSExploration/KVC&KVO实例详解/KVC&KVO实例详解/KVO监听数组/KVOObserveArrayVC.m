//
//  KVOObserveArrayVC.m
//  KVC&KVO实例详解
//
//  Created by fang wang on 16/12/21.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "KVOObserveArrayVC.h"

@interface KVOObserveArrayVC ()
@property (nonatomic, strong) NSMutableArray* arr;
@end

@implementation KVOObserveArrayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册观察者
    [self addObserver:self forKeyPath:@"arr" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

// 观察者监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"keypath ==%@  object ==%@, change == %@" ,keyPath, object , change);
    
}

// 向数组添加数据
- (IBAction)addObj:(UIButton *)sender {
    
    // 如果直接这样操作，发现并没有打印KVO的观察者监听方法
    // [self.arr addObject:@"1"];
    
    // 方法一：
//    [[self mutableArrayValueForKey:@"arr"] addObject:@"123"];
    
    // 方法二：
    [self willChangeValueForKey:@"arr"];
    [self.arr addObject:@"123"];
    [self didChangeValueForKey:@"arr"];

}

// 删除数组数据
- (IBAction)deleteObj:(UIButton *)sender {
    
    if (self.arr.count) {
        // 方法一：
//        [[self mutableArrayValueForKey:@"arr"] removeObject:@"123"];
        
        // 方法二：
        [self willChangeValueForKey:@"arr"];
        [self.arr removeObject:@"123"];
        [self didChangeValueForKey:@"arr"];
    }
}
/*
 小结：
    1. KVO模式中,对于基本数据类型是观察值的变化,但对于指针类型(OC中对象都是指针),是观察指针的地址是否变化.
        而数组中的数据变化时,数组的地址是不变的,所以KVO就认为数组没有变化
    2. 在第三步中,必须使用mutableArrayValueForKey的方式访问数组,才会收到数组内容变化的通知.
    3. 一定要记得最后使用完后,释放观察者,否则程序崩溃.
 
 */

- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}


// 移除观察者
- (void)dealloc{
    
     [self removeObserver:self forKeyPath:@"arr" context:NULL];
}

@end
