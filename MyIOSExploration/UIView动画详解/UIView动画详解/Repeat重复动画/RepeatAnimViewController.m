//
//  RepeatAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "RepeatAnimViewController.h"
#import <WDYLibrary/WDYLibrary.h>

@interface RepeatAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *greenView;

@end

@implementation RepeatAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)viewDidLayoutSubviews{
    
    [UIView animateWithDuration:1 animations:^{
        self.blueView.centerX = self.view.width - 100;
    }];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.redView.centerX = self.view.width - 100;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.greenView.centerX = self.view.width - 100;
    } completion:^(BOOL finished) {
        
    }];
}


@end
