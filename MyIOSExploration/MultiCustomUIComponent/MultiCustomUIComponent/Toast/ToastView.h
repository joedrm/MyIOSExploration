//
//  ToastView.h
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToastAnimator, ToastView;


/**
 ToastViewDelegate: 实现QMUIToastView显示和隐藏整个生命周期的回调
 */
@protocol ToastViewDelegate <NSObject>
/** 即将要显示toastView */
- (void)toastView:(ToastView *)toastView willShowInView:(UIView *)view;
/** 已经显示toastView */
- (void)toastView:(ToastView *)toastView didShowInView:(UIView *)view;
/** 即将要隐藏toastView */
- (void)toastView:(ToastView *)toastView willHideInView:(UIView *)view;
/** 已经隐藏toastView */
- (void)toastView:(ToastView *)toastView didHideInView:(UIView *)view;
@end


/**
 ToastView显示的位置

 - ToastViewPositionTop: 顶部
 - ToastViewPositionCenter: 中间
 - ToastViewPositionBottom: 底部
 */
typedef NS_ENUM(NSInteger, ToastViewPosition) {
    ToastViewPositionTop,
    ToastViewPositionCenter,
    ToastViewPositionBottom
};

@interface ToastView : UIView

/** 生成一个ToastView的唯一初始化方法，`view`的bound将会作为ToastView默认frame。*/
- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

/** parentView是ToastView初始化的时候穿进去的那个view */
@property(nonatomic, weak, readonly) UIView *parentView;

/**< delegate*/
@property (nonatomic, weak) id<ToastViewDelegate> delegate;

/** 显示ToastView。 是否需要通过动画显示。*/
- (void)showAnimated:(BOOL)animated;

/** 隐藏ToastView。是否需要通过动画隐藏。*/
- (void)hideAnimated:(BOOL)animated;

/** 在`delay`时间后隐藏ToastView。*/
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

/**
 * `ToastAnimator`可以让你通过实现一些协议来自定义ToastView显示和隐藏的动画。你可以继承`ToastAnimator`，
 然后实现`ToastAnimatorDelegate`中的方法，即可实现自定义的动画。如果不赋值，则会使用`ToastAnimator`中的默认动画。
 */
@property(nonatomic, strong) ToastAnimator *toastAnimator;

/**
 * 决定QMUIToastView的位置，目前有上中下三个位置，默认值是center。
 * 如果设置了top或者bottom，那么ToastView的布局规则是：
    顶部从marginInsets.top开始往下布局(ToastViewPositionTop) 和 底部从marginInsets.bottom开始往上布局(QMUIToastViewPositionBottom)。
 */
@property(nonatomic, assign) ToastViewPosition toastPosition;

/** 是否在ToastView隐藏的时候顺便把它从superView移除，默认为NO。*/
@property(nonatomic, assign) BOOL removeFromSuperViewWhenHide;


///////////////////

/** 会盖住整个superView，防止手指可以点击到ToastView下面的内容，默认透明。 */
@property(nonatomic, strong, readonly) UIView *maskView;

/** `contentView`下面的view，可以设置其：背景色、圆角、size等一些属性。*/
@property(nonatomic, strong) UIView *backgroundView;

/**
 * 所有类型的Toast都是通过给contentView赋值来实现的，每一个contentView都可以自己定义subview以及subview的样式和layout，
 * 最终作为ToastView的contentView来显示。如果contentView需要跟随ToastView的tintColor变化而变化，可以重写`tintColorDidChange`来实现。
 */
@property(nonatomic, strong) UIView *contentView;


///////////////////

/** 上下左右的偏移值。*/
@property(nonatomic, assign) CGPoint offset UI_APPEARANCE_SELECTOR;

/** ToastView距离上下左右的最小间距。*/
@property(nonatomic, assign) UIEdgeInsets marginInsets UI_APPEARANCE_SELECTOR;
@end





@interface ToastView (ToastTool)

/**
 * 工具方法。隐藏`view`里面的所有ToastView。
 *
 * @param view 即将隐藏的ToastView的superView。
 * @param animated 是否需要通过动画隐藏。
 *
 * @return 如果成功隐藏一个ToastView则返回YES，失败则NO。
 */
+ (BOOL)hideAllToastInView:(UIView *)view animated:(BOOL)animated;

/**
 * 工具方法。返回`view`里面最顶级的ToastView，如果没有则返回nil。
 *
 * @param view ToastView的superView。
 * @return 返回一个QMUIToastView的实例。
 */
+ (instancetype)toastInView:(UIView *)view;

/**
 * 工具方法。返回`view`里面所有的ToastView，如果没有则返回nil。
 *
 * @param view ToastView的superView。
 * @return 包含所有QMUIToastView的数组。
 */
+ (NSArray <ToastView *> *)allToastInView:(UIView *)view;

@end






