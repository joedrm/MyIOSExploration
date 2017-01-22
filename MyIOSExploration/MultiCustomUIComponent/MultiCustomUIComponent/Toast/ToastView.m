//
//  ToastView.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ToastView.h"
#import "ToastAnimator.h"
#import "ToastContentView.h"
#import "ToastBackgroundView.h"
#import "AppCommonHelper.h"
#import "CommonDefines.h"

@interface ToastView ()
@property(nonatomic, weak) NSTimer *hideDelayTimer;
@end

@implementation ToastView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用initWithView:初始化");
    return [self initWithView:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(NO, @"请使用initWithView:初始化");
    return [self initWithView:nil];
}


- (instancetype)initWithView:(UIView *)view{
    
    if (self = [super initWithFrame:view.frame]) {
        _parentView = view;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.toastPosition = ToastViewPositionCenter;
    
    // 顺序不能乱，先添加backgroundView再添加contentView
    self.backgroundView = [self defaultBackgrondView];
    self.contentView = [self defaultContentView];
    
    self.opaque = NO;
    self.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
    self.layer.allowsGroupOpacity = NO;
    
    self.tintColor = [UIColor whiteColor];
    
    _maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.maskView];
    
    [self registerNotifications];
}

- (ToastAnimator *)defaultAnimator {
    ToastAnimator *toastAnimator = [[ToastAnimator alloc] initWithToastView:self];
    return toastAnimator;
}

- (UIView *)defaultBackgrondView {
    ToastBackgroundView *backgroundView = [[ToastBackgroundView alloc] init];
    return backgroundView;
}

- (UIView *)defaultContentView {
    ToastContentView *contentView = [[ToastContentView alloc] init];
    return contentView;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    _parentView = nil;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    _backgroundView = backgroundView;
    self.backgroundView.alpha = 0.0;
    [self addSubview:self.backgroundView];
    [self setNeedsLayout];
}

- (void)setContentView:(UIView *)contentView {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        _contentView = nil;
    }
    _contentView = contentView;
    self.contentView.alpha = 0.0;
    [self addSubview:self.contentView];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = self.parentView.bounds;
    self.maskView.frame = self.bounds;
    
    CGFloat contentWidth = CGRectGetWidth(self.parentView.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.parentView.bounds);
    
    CGFloat limitWidth = contentWidth - UIEdgeInsetsGetHorizontalValue(self.marginInsets);
    CGFloat limitHeight = contentHeight - UIEdgeInsetsGetVerticalValue(self.marginInsets);
    
    if ([AppCommonHelper isKeyboardVisible]) {
        // 处理键盘相关逻辑
        contentHeight -= [AppCommonHelper lastKeyboardHeightInApplicationWindowWhenVisible];
    }
    
    if (self.contentView) {
        
        CGSize contentViewSize = [self.contentView sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
        CGFloat contentViewX = fmaxf(self.marginInsets.left, (contentWidth - contentViewSize.width) / 2) + self.offset.x;
        CGFloat contentViewY = fmaxf(self.marginInsets.top, (contentHeight - contentViewSize.height) / 2) + self.offset.y;
        
        if (self.toastPosition == ToastViewPositionTop) {
            contentViewY = self.marginInsets.top + self.offset.y;
        } else if (self.toastPosition == ToastViewPositionBottom) {
            contentViewY = contentHeight - contentViewSize.height - self.marginInsets.bottom + self.offset.y;
        }
        
        CGRect contentRect = CGRectFlatMake(contentViewX, contentViewY, contentViewSize.width, contentViewSize.height);
        self.contentView.frame = CGRectApplyAffineTransform(contentRect, self.contentView.transform);
    }
    if (self.backgroundView) {
        // backgroundView的frame跟contentView一样，contentView里面的subviews如果需要在视觉上跟backgroundView有个padding，那么就自己在自定义的contentView里面做。
        self.backgroundView.frame = self.contentView.frame;
    }
}


#pragma mark - 横竖屏

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    if (!self.parentView) {
        return;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)showAnimated:(BOOL)animated {
    
    // show之前需要layout以下，防止同一个tip切换不同的状态导致layout没更新
    [self setNeedsLayout];
    
    [self.hideDelayTimer invalidate];
    self.alpha = 1.0;
    
    if ([self.delegate respondsToSelector:@selector(toastView:willShowInView:)]) {
        [self.delegate toastView:self willShowInView:self.parentView];
    }
    
    if (animated) {
        if (!self.toastAnimator) {
            self.toastAnimator = [self defaultAnimator];
        }
        if (self.toastAnimator) {
            __weak __typeof(self)weakSelf = self;
            [self.toastAnimator showWithCompletion:^(BOOL finished) {
                [weakSelf didShow];
            }];
        }
    } else {
        self.backgroundView.alpha = 1.0;
        self.contentView.alpha = 1.0;
        [self didShow];
    }
}

- (void)didShow {
    if ([self.delegate respondsToSelector:@selector(toastView:didShowInView:)]) {
        [self.delegate toastView:self didShowInView:self.parentView];
    }
}

- (void)hideAnimated:(BOOL)animated {
    
    if ([self.delegate respondsToSelector:@selector(toastView:willHideInView:)]) {
        [self.delegate toastView:self willHideInView:self.parentView];
    }
    
    if (animated) {
        if (!self.toastAnimator) {
            self.toastAnimator = [self defaultAnimator];
        }
        if (self.toastAnimator) {
            __weak __typeof(self)weakSelf = self;
            [self.toastAnimator hideWithCompletion:^(BOOL finished) {
                [weakSelf didHide];
            }];
        }
    } else {
        self.backgroundView.alpha = 0.0;
        self.contentView.alpha = 0.0;
        [self didHide];
    }
}

- (void)didHide {
    
    if ([self.delegate respondsToSelector:@selector(toastView:didHideInView:)]) {
        [self.delegate toastView:self didHideInView:self.parentView];
    }
    
    [self.hideDelayTimer invalidate];
    self.alpha = 0.0;
    if (self.removeFromSuperViewWhenHide) {
        [self removeFromSuperview];
    }
}

- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleHideTimer:) userInfo:@(animated) repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.hideDelayTimer = timer;
}

- (void)handleHideTimer:(NSTimer *)timer {
    [self hideAnimated:[timer.userInfo boolValue]];
}

#pragma mark - UIAppearance

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    [self setNeedsLayout];
}

- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    _marginInsets = marginInsets;
    [self setNeedsLayout];
}

@end


@interface ToastView (UIAppearance)

@end

@implementation ToastView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    ToastView *appearance = [ToastView appearance];
    appearance.offset = CGPointZero;
    appearance.marginInsets = UIEdgeInsetsMake(20, 20, 20, 20);
}

@end

@implementation ToastView (ToastTool)

+ (BOOL)hideToastInView:(UIView *)view animated:(BOOL)animated {
    ToastView *toast = [self toastInView:view];
    if (toast != nil) {
        toast.removeFromSuperViewWhenHide = YES;
        [toast hideAnimated:animated];
        return YES;
    }
    return NO;
}

+ (BOOL)hideAllToastInView:(UIView *)view animated:(BOOL)animated {
    ToastView *toast = [self toastInView:view];
    if (toast != nil) {
        toast.removeFromSuperViewWhenHide = YES;
        [toast hideAnimated:animated];
        return YES;
    }
    return NO;
}

+ (instancetype)toastInView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (ToastView *)subview;
        }
    }
    return nil;
}

+ (NSArray <ToastView *> *)allToastInView:(UIView *)view {
    NSMutableArray *toastViews = [[NSMutableArray alloc] init];
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:self]) {
            [toastViews addObject:subview];
        }
    }
    return toastViews;
}

@end







