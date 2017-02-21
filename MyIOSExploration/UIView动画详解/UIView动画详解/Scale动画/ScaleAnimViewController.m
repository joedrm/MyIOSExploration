//
//  ScaleAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ScaleAnimViewController.h"

@interface ScaleAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *squreView;

@end

@implementation ScaleAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [UIView animateWithDuration:1 animations:^{
        self.squreView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    }];
}



@end
