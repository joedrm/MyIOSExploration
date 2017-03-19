//
//  LayoutAnimateViewController.m
//  AutoLayoutPractice
//
//  Created by wdy on 2017/3/19.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LayoutAnimateViewController.h"

@interface LayoutAnimateViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidthConstrain;

@end

@implementation LayoutAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.redViewWidthConstrain.constant = 100;
    [UIView animateWithDuration:1 animations:^{
        // 强制刷新
        [self.view layoutIfNeeded];
    }];
}

@end
