//
//  PriorityViewController.m
//  AutoLayoutPractice
//
//  Created by wdy on 2017/3/19.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PriorityViewController.h"

@interface PriorityViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;

@end

@implementation PriorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    [self.blueView removeFromSuperview];
}

@end
