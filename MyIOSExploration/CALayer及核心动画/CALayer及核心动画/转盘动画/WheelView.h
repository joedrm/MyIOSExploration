//
//  WheelView.h
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelView : UIView

+ (instancetype)wheelView;
// 开始旋转
- (void)startRotation;
// 停止旋转
- (void)stop;

@end
