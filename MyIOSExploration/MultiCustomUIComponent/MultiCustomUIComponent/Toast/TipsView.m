//
//  TipsView.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TipsView.h"
#import "ToastContentView.h"

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
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips_done"]];
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
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips_error"]];
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
    self.contentCustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips_info"]];
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

+ (TipsView *)createTipsToView:(UIView *)view {
    TipsView *tips = [[TipsView alloc] initWithView:view];
    [view addSubview:tips];
    tips.removeFromSuperViewWhenHide = YES;
    return tips;
}


@end
