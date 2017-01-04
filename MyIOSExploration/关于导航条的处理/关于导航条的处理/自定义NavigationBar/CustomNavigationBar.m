//
//  CustomNavigationBar.m
//  关于导航条的处理
//
//  Created by fang wang on 17/1/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar




- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    bezierPath.lineWidth = 4.f;
    [[UIColor orangeColor] setStroke];
    [[UIColor redColor] setFill];
    [bezierPath fill];
    [bezierPath stroke];
}

@end
