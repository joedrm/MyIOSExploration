//
//  DelegateTestView.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "DelegateTestView.h"

@interface DelegateTestView ()
@property (nonatomic, strong) UIButton* btn;
@end

@implementation DelegateTestView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{

    UIButton* btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.frame = CGRectMake(10, 10, 40, 30);
    self.btn = btn;
}

- (void)clicked:(UIButton *)sender{

    [self.btnSubject sendNext:@"按钮被点击了..."];
}

- (RACSubject *)btnSubject{
    
    if (!_btnSubject) {
        _btnSubject = [RACSubject subject];
    }
    return _btnSubject;
}



@end
