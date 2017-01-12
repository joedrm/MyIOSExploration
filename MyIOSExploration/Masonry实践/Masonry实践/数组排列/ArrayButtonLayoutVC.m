//
//  ArrayButtonLayoutVC.m
//  Masonry实践
//
//  Created by fang wang on 17/1/9.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "ArrayButtonLayoutVC.h"

@interface ArrayButtonLayoutVC ()

@end

@implementation ArrayButtonLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray* btnTitleArr = @[@"Commit", @"Cancel", @"Think About Later"];
    NSMutableArray* arr = [NSMutableArray array];
    for (NSString* title in btnTitleArr) {
        UIButton* btn = [[UIButton alloc] init];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor redColor].CGColor;
        btn.layer.borderWidth = 2.0f;
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    
    // axisType: 轴线方向
    // fixedSpacing: 间隔大小
    // leadSpacing: 头部间隔
    // tailSpacing: 尾部间隔
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(84);
        make.height.mas_equalTo(40);
    }];
}


@end
