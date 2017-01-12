//
//  Case1ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case1ViewController.h"

@interface Case1ViewController ()
@property (nonatomic, strong) UILabel* label1;
@property (nonatomic, strong) UILabel* label2;
@end

@implementation Case1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"并排居中";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 容器view
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(100);
    }];
    
    // label1
    UILabel* label1 = [[UILabel alloc] init];
    label1.text = @"我是label1,";
    label1.backgroundColor = [UIColor redColor];
    label1.textColor = [UIColor whiteColor];
    [contentView addSubview:label1];
    // label1: 位于左上角
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).with.offset(5);
        make.left.equalTo(contentView.mas_left).with.offset(2);
        // 40高度
        make.height.equalTo(@50);
    }];

    // label2
    UILabel* label2 = [[UILabel alloc] init];
    label2.text = @"我是label2";
    label2.backgroundColor = [UIColor blackColor];
    label2.textColor = [UIColor whiteColor];
    [contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).with.offset(2);
        make.top.equalTo(contentView.mas_top).with.offset(5);
        
        //右边的间隔保持大于等于2，注意是lessThanOrEqual
        //这里的“lessThanOrEqualTo”放在从左往右的X轴上考虑会更好理解。
        //即：label2的右边界的X坐标值“小于等于”containView的右边界的X坐标值。
        make.right.lessThanOrEqualTo(contentView.mas_right).with.offset(-2);
        
        //只设置高度40
        make.height.equalTo(@50);
    }];
    
    //设置label1的content hugging 为1000
    [label1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置label1的content compression 为1000
    [label1 setContentCompressionResistancePriority:UILayoutPriorityRequired  forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置右边的label2的content hugging 为1000
    [label2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置右边的label2的content compression 为250
    [label2 setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    self.label1 = label1;
    self.label2 = label2;
    
    for (int i = 0; i<2; i++) {
        UIStepper* sp = [[UIStepper alloc] init];
        sp.tag = i;
        [self.view addSubview:sp];
        [sp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_bottom).offset(30);
            (i == 1)?make.right.equalTo(self.view).offset(-20):make.left.equalTo(self.view).offset(20);
        }];
        [sp addTarget:self action:@selector(addLabelContent:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)addLabelContent:(UIStepper *)sender {
    
    switch (sender.tag) {
        case 0:
            self.label1.text = [self getLabelContentWithCount:(NSUInteger)sender.value];
            break;
            
        case 1:
            self.label2.text = [self getLabelContentWithCount:(NSUInteger)sender.value];
            break;
            
        default:
            break;
    }
}

- (NSString *)getLabelContentWithCount:(NSUInteger)count {
    NSMutableString *ret = [NSMutableString new];
    
    for (NSUInteger i = 0; i <= count; i++) {
        [ret appendString:@"我是增加的内容,"];
    }
    
    return ret.copy;
}



@end
