//
//  WDYHeaderView.m
//  UITableViewHeader各种效果
//
//  Created by wangdongyang on 16/9/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "WDYHeaderView.h"

@implementation WDYHeaderView

+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WDYHeaderView" owner:nil options:nil] firstObject];
}

@end
