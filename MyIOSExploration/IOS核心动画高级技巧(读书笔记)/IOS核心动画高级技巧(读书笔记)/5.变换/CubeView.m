//
//  CubeView.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2016/12/31.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "CubeView.h"

@implementation CubeView

+ (instancetype)cubeView{
    
    return [CubeView loadViewFromNib];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    
}

@end
