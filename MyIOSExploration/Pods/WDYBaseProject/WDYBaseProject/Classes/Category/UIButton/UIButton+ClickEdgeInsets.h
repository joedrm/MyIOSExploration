//
//  UIButton+ClickEdgeInsets.h
//  Categories
//
//  Created by lisong on 2016/10/14.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 改变按钮的响应区域 */
@interface UIButton (ClickEdgeInsets)

/** 上左下右分别增加或减小多少  正数为增加 负数为减小*/
@property (nonatomic, assign) UIEdgeInsets clickEdgeInsets;

@end
