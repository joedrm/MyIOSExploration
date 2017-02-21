//
//  OpacityAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "OpacityAnimViewController.h"

@interface OpacityAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueSqureView;

@end

@implementation OpacityAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIView animateWithDuration:1 animations:^{
        self.blueSqureView.alpha = 0.1;
    }];
}


@end
