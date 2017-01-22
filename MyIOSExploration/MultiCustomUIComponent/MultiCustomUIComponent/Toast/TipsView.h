//
//  TipsView.h
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ToastView.h"

@interface TipsView : ToastView

/// 实例方法：需要自己addSubview，hide之后不会自动removeFromSuperView

- (void)showWithText:(NSString *)text;
- (void)showWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showWithText:(NSString *)text detailText:(NSString *)detailText;
- (void)showWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showLoading;
- (void)showLoading:(NSString *)text;
- (void)showLoadingHideAfterDelay:(NSTimeInterval)delay;
- (void)showLoading:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showLoading:(NSString *)text detailText:(NSString *)detailText;
- (void)showLoading:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showSucceed:(NSString *)text;
- (void)showSucceed:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showSucceed:(NSString *)text detailText:(NSString *)detailText;
- (void)showSucceed:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showError:(NSString *)text;
- (void)showError:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showError:(NSString *)text detailText:(NSString *)detailText;
- (void)showError:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

- (void)showInfo:(NSString *)text;
- (void)showInfo:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showInfo:(NSString *)text detailText:(NSString *)detailText;
- (void)showInfo:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay;

/// 类方法：主要用在局部一次性使用的场景，hide之后会自动removeFromSuperView

+ (TipsView *)createTipsToView:(UIView *)view;

+ (TipsView *)showWithText:(NSString *)text inView:(UIView *)view;
+ (TipsView *)showWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TipsView *)showWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (TipsView *)showWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TipsView *)showLoadingInView:(UIView *)view;
+ (TipsView *)showLoading:(NSString *)text inView:(UIView *)view;
+ (TipsView *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TipsView *)showLoading:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TipsView *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (TipsView *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TipsView *)showSucceed:(NSString *)text inView:(UIView *)view;
+ (TipsView *)showSucceed:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TipsView *)showSucceed:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (TipsView *)showSucceed:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TipsView *)showError:(NSString *)text inView:(UIView *)view;
+ (TipsView *)showError:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TipsView *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (TipsView *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (TipsView *)showInfo:(NSString *)text inView:(UIView *)view;
+ (TipsView *)showInfo:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
+ (TipsView *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view;
+ (TipsView *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;
@end
