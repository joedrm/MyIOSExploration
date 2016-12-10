//
//  DrawTextView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "DrawTextView.h"

@implementation DrawTextView

- (void)drawRect:(CGRect)rect{
    
    NSString* str = @"朝辞白帝彩云间，千里江陵一日还。两岸猿声啼不住，轻舟已过万重山。";
    
    NSMutableDictionary* attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    attrsDict[NSForegroundColorAttributeName] = [UIColor blueColor];
    // 描边颜色
    attrsDict[NSStrokeColorAttributeName] = [UIColor redColor];
    // 描边宽度
    attrsDict[NSStrokeWidthAttributeName] = @4;
    
    // 设置阴影
    NSShadow *shaw = [[NSShadow alloc] init];
    shaw.shadowColor = [UIColor blackColor];
    shaw.shadowOffset = CGSizeMake(10, 10);
    shaw.shadowBlurRadius = 3.0;
    attrsDict[NSShadowAttributeName] = shaw;
    
    // 不会自动换行
//    [str drawAtPoint:CGPointZero withAttributes:attrsDict];
    
    // 会自动换行
    [str drawInRect:rect withAttributes:attrsDict];
    
}

@end
