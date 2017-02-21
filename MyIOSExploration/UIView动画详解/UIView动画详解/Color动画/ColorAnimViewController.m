//
//  ColorAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ColorAnimViewController.h"

@interface ColorAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *squreView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@end

@implementation ColorAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIView animateWithDuration:1 animations:^{
        self.squreView.backgroundColor = [UIColor redColor];
        self.labelView.textColor = [UIColor whiteColor];
    }];
    
}



@end
