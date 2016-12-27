//
//  UIView+EqualSpace.h
//  Masonry实践
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EqualSpace)

// 水平方向上多个view实现等间距
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;

// 垂直方向上多个view实现等间距
- (void) distributeSpacingVerticallyWith:(NSArray*)views;

@end
