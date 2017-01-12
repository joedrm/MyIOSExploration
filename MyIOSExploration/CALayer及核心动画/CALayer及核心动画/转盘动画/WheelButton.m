//
//  WheelButton.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/24.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "WheelButton.h"

@implementation WheelButton


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height*0.5);
    if (CGRectContainsPoint(rect, point)) {
        return [super hitTest:point withEvent:event];
    }else{
        return nil;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = 40;
    CGFloat imageH = 48;
    CGFloat imageX = (contentRect.size.width - imageW)*0.5;
    CGFloat imageY = 20;
    
    CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
    return rect;
}

// 重写父类方法，去掉高亮效果
- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
