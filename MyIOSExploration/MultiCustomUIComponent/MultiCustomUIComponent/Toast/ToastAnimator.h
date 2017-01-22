//
//  ToastAnimator.h
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToastView.h"

@class ToastView;

/**
 * `ToastAnimatorDelegate`是所有`ToastAnimator`或者其子类必须遵循的协议，是整个动画过程实现的地方。
 */
@protocol ToastAnimatorDelegate <NSObject>

@required

- (void)showWithCompletion:(void (^)(BOOL finished))completion;

- (void)hideWithCompletion:(void (^)(BOOL finished))completion;

- (BOOL)isShowing;

- (BOOL)isAnimating;

@end

// TODO: 实现多种animation类型

typedef NS_ENUM(NSInteger, ToastAnimationType) {
    ToastAnimationTypeFade   = 0,
    ToastAnimationTypeZoom,
    ToastAnimationTypeSlide
};

@interface ToastAnimator : NSObject <ToastAnimatorDelegate>

- (instancetype)initWithToastView:(ToastView *)toastView NS_DESIGNATED_INITIALIZER;


/**
 * 获取初始化传进来的QMUIToastView。
 */
@property(nonatomic, weak, readonly) ToastView *toastView;

/**
 * 指定QMUIToastAnimator做动画的类型type。此功能暂时未实现，目前所有动画类型都是QMUIToastAnimationTypeFade。
 */
@property(nonatomic, assign) ToastAnimationType animationType;
@end
