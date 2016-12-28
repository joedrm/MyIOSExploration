//
//  UIControl+Delay.h
//  Categories
//
//  Created by lisong on 2016/10/14.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Delay)

/** 每次响应的间隔 */
@property (assign, nonatomic) NSTimeInterval acceptEventInterval;

@end
