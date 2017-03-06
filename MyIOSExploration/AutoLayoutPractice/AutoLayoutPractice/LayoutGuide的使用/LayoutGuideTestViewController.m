//
//  LayoutGuideTestViewController.m
//  AutoLayoutPractice
//
//  Created by fang wang on 17/3/6.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LayoutGuideTestViewController.h"

@interface LayoutGuideTestViewController ()

@end

@implementation LayoutGuideTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* testView = [[UIView alloc] init];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    
    // 在没有navigationBar的情况下，statusBar的高度不被考虑，于是你又不得不做出判断，当没有navigationBar的情况下，view上面留20像素来避免被statusBar挡住。
    // 无论是否有 navigationBar 或 tabBar 都能够正常显示
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
}


@end
