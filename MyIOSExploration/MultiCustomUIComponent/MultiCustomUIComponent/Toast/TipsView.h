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

/*

UIView *parentView = self.navigationController.view;
NSString* title = self.dataSource [indexPath.row];
if ([title isEqualToString:@"Loading"]) {
    TipsView *tips = [TipsView createTipsToView:parentView];
    ToastContentView *contentView = (ToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(90, 90);
    [tips showLoadingHideAfterDelay:2];
    
    // 如果不需要修改contentView的样式，也可以直接使用下面这个工具方法
    // [TipsView showLoadingInView:parentView hideAfterDelay:2];
    
} else if ([title isEqualToString:@"Loading With Text"]) {
    [TipsView showLoading:@"加载中..." inView:parentView hideAfterDelay:2];
    
} else if ([title isEqualToString:@"Tips For Succeed"]) {
    [TipsView showSucceed:@"加载成功" inView:parentView hideAfterDelay:2];
    
} else if ([title isEqualToString:@"Tips For Error"]) {
    [TipsView showError:@"加载失败，请检查网络情况" inView:parentView hideAfterDelay:2];
    
} else if ([title isEqualToString:@"Tips For Info"]) {
    [TipsView showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
    
} else if ([title isEqualToString:@"Custom TintColor"]) {
    TipsView *tips = [TipsView showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
    tips.tintColor = [UIColor whiteColor];
    
} else if ([title isEqualToString:@"Custom BackgroundView Style"]) {
    TipsView *tips = [TipsView showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" inView:parentView hideAfterDelay:2];
    ToastBackgroundView *backgroundView = (ToastBackgroundView *)tips.backgroundView;
    backgroundView.shouldBlurBackgroundView = YES;
    backgroundView.styleColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:0.8/1];
    //UIColorMakeWithRGBA(232, 232, 232, 0.8);
    tips.tintColor = [UIColor blackColor];
    
} else if ([title isEqualToString:@"Custom Content View"]) {
    TipsView *tips = [TipsView createTipsToView:parentView];
    tips.toastPosition = ToastViewPositionCenter;//ToastViewPositionBottom;
    ToastBackgroundView *backgroundView = (ToastBackgroundView *)tips.backgroundView;
    backgroundView.shouldBlurBackgroundView = YES;
    backgroundView.styleColor = [UIColor colorWithRed:232.0/255 green:232.0/255 blue:232.0/255 alpha:0.8/1];
    CustomToastAnimator *customAnimator = [[CustomToastAnimator alloc] initWithToastView:tips];
    tips.toastAnimator = customAnimator;
    CustomToastContentView *customContentView = [[CustomToastContentView alloc] init];
    [customContentView renderWithImage:[UIImage imageNamed:@"apple-touch-icon"] text:@"什么是QMUIToastView" detailText:@"QMUIToastView用于临时显示某些信息，并且会在数秒后自动消失。这些信息通常是轻量级操作的成功信息。"];
    tips.contentView = customContentView;
    [tips showAnimated:YES];
    [tips hideAnimated:YES afterDelay:4];
    
} else if ([title isEqualToString:@"Custom Animator"]) {
    TipsView *tips = [TipsView createTipsToView:parentView];
    CustomToastAnimator *customAnimator = [[CustomToastAnimator alloc] initWithToastView:tips];
    tips.toastAnimator = customAnimator;
    [tips showInfo:@"活动已经结束" detailText:@"本次活动时间为2月1号-2月15号" hideAfterDelay:2];
    
}

*/
