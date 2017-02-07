//
//  TipsView.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TipsView.h"
#import "ToastContentView.h"
//#import "UIView+Find.h"
#import "UIViewController+Current.h"
#import "CustomToastAnimator.h"
#import "NSBundle+MyLibrary.h"

@interface TipsView ()

@property(nonatomic, strong) UIView *contentCustomView;
@end

@implementation TipsView

- (void)showWithText:(NSString *)text {
    [self showWithText:text detailText:nil hideAfterDelay:0];
}

- (void)showWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showWithText:text detailText:nil hideAfterDelay:delay];
}

- (void)showWithText:(NSString *)text detailText:(NSString *)detailText {
    [self showWithText:text detailText:detailText hideAfterDelay:0];
}

- (void)showWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = nil;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showLoading {
    [self showLoading:nil hideAfterDelay:0];
}

- (void)showLoadingHideAfterDelay:(NSTimeInterval)delay {
    [self showLoading:nil hideAfterDelay:delay];
}

- (void)showLoading:(NSString *)text {
    [self showLoading:text hideAfterDelay:0];
}

- (void)showLoading:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showLoading:text detailText:nil hideAfterDelay:delay];
}

- (void)showLoading:(NSString *)text detailText:(NSString *)detailText {
    [self showLoading:text detailText:detailText hideAfterDelay:0];
}
- (void)showLoading:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    self.contentCustomView = indicator;
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showSucceed:(NSString *)text {
    [self showSucceed:text detailText:nil hideAfterDelay:0];
}

- (void)showSucceed:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showSucceed:text detailText:nil hideAfterDelay:delay];
}

- (void)showSucceed:(NSString *)text detailText:(NSString *)detailText {
    [self showSucceed:text detailText:detailText hideAfterDelay:0];
}

- (void)showSucceed:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = [[UIImageView alloc] initWithImage:[NSBundle tips_doneImageClass:self.class]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showError:(NSString *)text {
    [self showError:text detailText:nil hideAfterDelay:0];
}

- (void)showError:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showError:text detailText:nil hideAfterDelay:delay];
}

- (void)showError:(NSString *)text detailText:(NSString *)detailText {
    [self showError:text detailText:detailText hideAfterDelay:0];
}

- (void)showError:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = [[UIImageView alloc] initWithImage:[NSBundle tips_errorImageClass:self.class]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showInfo:(NSString *)text {
    [self showInfo:text detailText:nil hideAfterDelay:0];
}

- (void)showInfo:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    [self showInfo:text detailText:nil hideAfterDelay:delay];
}

- (void)showInfo:(NSString *)text detailText:(NSString *)detailText {
    [self showInfo:text detailText:detailText hideAfterDelay:0];
}

- (void)showInfo:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    self.contentCustomView = [[UIImageView alloc] initWithImage:[NSBundle tips_infoImageClass:self.class]];
    [self showTipWithText:text detailText:detailText hideAfterDelay:delay];
}

- (void)showTipWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    
    ToastContentView *contentView = (ToastContentView *)self.contentView;
    contentView.customView = self.contentCustomView;
    
    contentView.textLabelText = text ?: @"";
    contentView.detailTextLabelText = detailText ?: @"";
    
    [self showAnimated:YES];
    
    if (delay > 0) {
        [self hideAnimated:YES afterDelay:delay];
    }
}

+ (TipsView *)showWithText:(NSString *)text inView:(UIView *)view {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:0];
}

+ (TipsView *)showWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showWithText:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (TipsView *)showWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showWithText:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (TipsView *)showWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    TipsView *tips = [self createTipsToView:view];
    [tips showWithText:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (TipsView *)showLoadingInView:(UIView *)view {
    return [self showLoading:nil detailText:nil inView:view hideAfterDelay:0];
}

+ (TipsView *)showLoading:(NSString *)text inView:(UIView *)view {
    return [self showLoading:text detailText:nil inView:view hideAfterDelay:0];
}

+ (TipsView *)showLoadingInView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoading:nil detailText:nil inView:view hideAfterDelay:delay];
}

+ (TipsView *)showLoading:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showLoading:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (TipsView *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showLoading:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (TipsView *)showLoading:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    TipsView *tips = [self createTipsToView:view];
    [tips showLoading:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (TipsView *)showSucceed:(NSString *)text inView:(UIView *)view {
    return [self showSucceed:text detailText:nil inView:view hideAfterDelay:0];
}

+ (TipsView *)showSucceed:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showSucceed:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (TipsView *)showSucceed:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showSucceed:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (TipsView *)showSucceed:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    TipsView *tips = [self createTipsToView:view];
    [tips showSucceed:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (TipsView *)showError:(NSString *)text inView:(UIView *)view {
    return [self showError:text detailText:nil inView:view hideAfterDelay:0];
}

+ (TipsView *)showError:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showError:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (TipsView *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showError:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (TipsView *)showError:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    TipsView *tips = [self createTipsToView:view];
    [tips showError:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

+ (TipsView *)showInfo:(NSString *)text inView:(UIView *)view {
    return [self showInfo:text inView:view];
}

+ (TipsView *)showInfo:(NSString *)text inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    return [self showInfo:text detailText:nil inView:view hideAfterDelay:delay];
}

+ (TipsView *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    return [self showInfo:text detailText:detailText inView:view hideAfterDelay:0];
}

+ (TipsView *)showInfo:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
    TipsView *tips = [self createTipsToView:view];
    [tips showInfo:text detailText:detailText hideAfterDelay:delay];
    return tips;
}

#pragma mark - 快速显示在当前的View上

+ (TipsView *)showWithText:(NSString *)text{
    [self hideToastView];
    return [self showWithText:text inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showWithText:text inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}
+ (TipsView *)showWithText:(NSString *)text detailText:(NSString *)detailText{
    [self hideToastView];
    return [self showWithText:text detailText:detailText inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay{
    return [self showWithText:text detailText:detailText inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}

+ (TipsView *)showLoading{
    [self hideToastView];
    TipsView* view = [self showLoadingInView:[UIViewController currentNavigatonController].view];
    return view;
}
+ (TipsView *)showLoading:(NSString *)text{
    [self hideToastView];
    return [self showLoading:text inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showLoadingHideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showLoadingInView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}
+ (TipsView *)showLoading:(NSString *)text hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showLoading:text inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}
+ (TipsView *)showLoading:(NSString *)text detailText:(NSString *)detailText{
    [self hideToastView];
    return [self showLoading:text detailText:detailText inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showLoading:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showLoading:text detailText:detailText inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}

+ (TipsView *)showSucceed:(NSString *)text{
    [self hideToastView];
    return [self showSucceed:text inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showSucceed:(NSString *)text hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showSucceed:text inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}
+ (TipsView *)showSucceed:(NSString *)text detailText:(NSString *)detailText{
    [self hideToastView];
    return [self showSucceed:text detailText:detailText inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showSucceed:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showSucceed:text detailText:detailText inView:[UIViewController currentNavigatonController].view
              hideAfterDelay:delay];
}

+ (TipsView *)showError:(NSString *)text{
    [self hideToastView];
    return [self showError:text inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showError:(NSString *)text hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showError:text inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}
+ (TipsView *)showError:(NSString *)text detailText:(NSString *)detailText{
    [self hideToastView];
    return [self showError:text detailText:detailText inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showError:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showError:text detailText:detailText inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}

+ (TipsView *)showInfo:(NSString *)text{
    [self hideToastView];
    return [self showInfo:text inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showInfo:(NSString *)text hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showInfo:text inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}
+ (TipsView *)showInfo:(NSString *)text detailText:(NSString *)detailText{
    [self hideToastView];
    return [self showInfo:text detailText:detailText inView:[UIViewController currentNavigatonController].view];
}
+ (TipsView *)showInfo:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay{
    [self hideToastView];
    return [self showInfo:text detailText:detailText inView:[UIViewController currentNavigatonController].view hideAfterDelay:delay];
}

+ (void)hideToastView{
    [TipsView hideAllToastInView:[UIViewController currentNavigatonController].view animated:YES];
}

+ (TipsView *)createTipsToView:(UIView *)view {
    TipsView *tips = [[TipsView alloc] initWithView:view];
    [view addSubview:tips];
    tips.removeFromSuperViewWhenHide = YES;
    // 加入自定义动画
    CustomToastAnimator *customAnimator = [[CustomToastAnimator alloc] initWithToastView:tips];
    tips.toastAnimator = customAnimator;
    return tips;
}


@end
