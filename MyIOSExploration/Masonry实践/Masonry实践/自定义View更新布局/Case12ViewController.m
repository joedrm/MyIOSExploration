//
//  Case12ViewController.m
//  Masonry实践
//
//  Created by fang wang on 17/1/9.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "Case12ViewController.h"
#import "CustomUIView.h"

@interface Case12ViewController ()

@property(strong,nonatomic)CustomUIView *testView;
@end

@implementation Case12ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!self.testView) {
        self.testView = [[CustomUIView alloc]init];
        self.testView.leftWidth = 120;
        self.testView.rightWidth = 0;
        [self.view addSubview:self.testView];
        
        [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(300);
            make.center.mas_equalTo(self.view).centerOffset(CGPointMake(10, 10));
        }];
        
        //增加点击事件
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.testView addGestureRecognizer:singleTap];
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    self.testView.leftWidth = 0;
    self.testView.rightWidth = 150;
}



@end
