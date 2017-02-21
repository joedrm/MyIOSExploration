//
//  PositionAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PositionAnimViewController.h"
#import <WDYLibrary/WDYLibrary.h>

@interface PositionAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *redSqureView;

@end

@implementation PositionAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 此处拿到的 Frame 或者 Bounds 的值是准确
    NSLog(@"%@, %@", NSStringFromCGPoint(self.view.center), NSStringFromCGRect(self.view.bounds));
}

- (void)viewDidLayoutSubviews{

    
    [UIView animateWithDuration:1 animations:^{
        
        NSLog(@"%@, %@", NSStringFromCGPoint(self.view.center), NSStringFromCGRect(self.view.bounds));
        
        CGPoint center = self.redSqureView.center;
        center.x = self.view.center.x;
        center.y = self.view.center.y;
        self.redSqureView.center = center;
        
    }];
}


@end
