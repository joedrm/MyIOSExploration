//
//  SetKVOViewController.m
//  KVC&KVO实例详解
//
//  Created by wdy on 2016/12/28.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "SetKVOViewController.h"

@interface SetKVOViewController ()
@property (nonatomic, strong) NSDate *now;
@end

@implementation SetKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"now" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"1");
    
    // “手动触发self.now的KVO”，
    [self willChangeValueForKey:@"now"];
    
    NSLog(@"2");
    
    // “手动触发self.now的KVO”，
    [self didChangeValueForKey:@"now"];
    
    NSLog(@"4");
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    NSLog(@"3");
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"now"];
}

@end
