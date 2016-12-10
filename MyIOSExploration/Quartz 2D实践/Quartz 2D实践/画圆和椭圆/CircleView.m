//
//  CircleView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

// 画椭圆

- (void)drawRect:(CGRect)rect
{
    CGSize size = rect.size;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, size.height*0.4, size.width - 20, size.height*0.3)];
    
    [[UIColor blueColor] set];
    
    // 此处使用了 UIBezierPath提供了绘制圆的方法
    // 此方法内部实现了：1. 获取上下文 -》2. 绘制路径 -》3 把路径保存到上下文中 -》4 把内容渲染到View上
    // 并且此方法只能在 - (void)drawRect:(CGRect)rect 方法获取上下文
    [path fill];
}

@end
