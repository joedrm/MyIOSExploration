//
//  Case10ViewController.m
//  Masonry实践
//
//  Created by fang wang on 17/1/9.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "Case11ViewController.h"

@interface Case11ViewController ()

@end

@implementation Case11ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* label1 = [[UILabel alloc] init];
    label1.backgroundColor = [UIColor blueColor];
    label1.text = @"label1测试不设高度时它的默认值,再增加文字长度时的情况";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.left.mas_equalTo(20);
        
        // 至少至右边有80的空间，优先级设高优先级，如果文字不够长 它会以文字本来的宽度
        make.right.mas_lessThanOrEqualTo(-80).with.priorityHigh();
    }];
    
    UILabel* label2 = [[UILabel alloc] init];
    label2.backgroundColor = [UIColor redColor];
    label2.text = @"确认";
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1);
        make.left.mas_equalTo(label1.mas_right).offset(20);
    }];
    
    // ------------- 与上面对比 ---------------
    
    UILabel* label3 = [[UILabel alloc] init];
    label3.backgroundColor = [UIColor blueColor];
    label3.text = @"label1测试不设高度时它的默认值,";
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130);
        make.left.mas_equalTo(20);
        
        // 至少至右边有80的空间，优先级设高优先级，如果文字不够长 它会以文字本来的宽度
        make.right.mas_lessThanOrEqualTo(-80).with.priorityHigh();
    }];
    
    UILabel* label4 = [[UILabel alloc] init];
    label4.backgroundColor = [UIColor redColor];
    label4.text = @"确认";
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label3);
        make.left.mas_equalTo(label3.mas_right).offset(20);
    }];
}


@end
