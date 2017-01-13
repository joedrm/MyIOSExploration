//
//  ModalPresentationViewController.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/13.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ModalPresentationViewController.h"
#import <objc/runtime.h>

/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE float
flatfSpecificScale(float floatValue, float scale) {
    scale = scale == 0 ? ([[UIScreen mainScreen] scale]) : scale;
    CGFloat flattedValue = ceilf(floatValue * scale) / scale;
    return flattedValue;
}

/**
 *  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flatf() 函数。
 */
CG_INLINE float
flatf(float floatValue) {
    return flatfSpecificScale(floatValue, 0);
}
/// 用于居中运算
CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return flatf((parent - child) / 2.0);
}
/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

CGSize screenSizeFor47Inch() {
    return CGSizeMake(375, 667);
};


#define UIColorMakeWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define ViewAnimationOptionsCurveOut (7<<16)
#define ViewAnimationOptionsCurveIn (8<<16)

@interface UIViewController ()
@property(nonatomic, weak, readwrite) ModalPresentationViewController *modalPresentedViewController;
@end



@implementation ModalPresentationViewController (UIAppearance)

static ModalPresentationViewController *appearance;
+ (instancetype)appearance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initDefaultAppearance];
    });
    return appearance;
}

+ (void)initDefaultAppearance {
    if (!appearance) {
        appearance = [[self alloc] init];
    }
    appearance.animationStyle = ModalPresentationAnimationStyleFade;
    appearance.contentViewMargins = UIEdgeInsetsMake(20, 20, 20, 20);
    appearance.maximumContentViewWidth = (screenSizeFor47Inch().width - UIEdgeInsetsGetHorizontalValue(appearance.contentViewMargins));
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self appearance];
    });
}

@end

@interface ModalPresentationViewController ()

@property(nonatomic, strong) ModalPresentationWindow *containerWindow;
@property(nonatomic, assign) BOOL appearAnimated;
@property(nonatomic, copy) void (^appearCompletionBlock)(BOOL finished);

@property(nonatomic, assign) BOOL disappearAnimated;
@property(nonatomic, copy) void (^disappearCompletionBlock)(BOOL finished);

@property(nonatomic, assign) CGFloat keyboardHeight;

/// 标志是否已经走过一次viewWillAppear了，用于hideInView的情况
@property(nonatomic, assign) BOOL hasAlreadyViewWillDisappear;

@property(nonatomic, strong) UITapGestureRecognizer *dimmingViewTapGestureRecognizer;
@end

@implementation ModalPresentationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if (appearance) {
            self.animationStyle = appearance.animationStyle;
            self.contentViewMargins = appearance.contentViewMargins;
            self.maximumContentViewWidth = appearance.maximumContentViewWidth;
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.modalPresentationStyle = UIModalPresentationCustom;
            self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
        }
        
        [self initDefaultDimmingViewWithoutAddToView];
    }
    return self;
}

- (void)dealloc {
    _containerWindow = nil;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    // 屏蔽对childViewController的生命周期函数的自动调用，改为手动控制
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.dimmingView && !self.dimmingView.superview) {
        [self.view addSubview:self.dimmingView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.dimmingView.frame = self.view.bounds;
    
    CGRect contentViewFrame = [self contentViewFrameForShowing];
    if (self.layoutBlock) {
        self.layoutBlock(self.view.bounds, self.keyboardHeight, contentViewFrame);
    } else {
        self.contentView.frame = contentViewFrame;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.containerWindow) {
        // 只有使用showWithAnimated:completion:显示出来的浮层，才需要修改之前就记住的animated的值
        animated = self.appearAnimated;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.contentViewController) {
        self.contentViewController.modalPresentedViewController = self;
        [self.contentViewController beginAppearanceTransition:YES animated:animated];
    }
    
    [self dimmedApplicationWindow];
    
    void (^didShownCompletion)(BOOL finished) = ^(BOOL finished) {
        if (self.contentViewController) {
            [self.contentViewController endAppearanceTransition];
        }
        
        _visible = YES;
        
        if (self.appearCompletionBlock) {
            self.appearCompletionBlock(finished);
            self.appearCompletionBlock = nil;
        }
        
        self.appearAnimated = NO;
    };
    
    if (animated) {
        [self.view addSubview:self.contentView];
        [self.view layoutIfNeeded];
        
        CGRect contentViewFrame = [self contentViewFrameForShowing];
        if (self.showingAnimation) {
            // 使用自定义的动画
            if (self.layoutBlock) {
                self.layoutBlock(self.view.bounds, self.keyboardHeight, contentViewFrame);
                contentViewFrame = self.contentView.frame;
            }
            self.showingAnimation(self.dimmingView, self.view.bounds, self.keyboardHeight, contentViewFrame, didShownCompletion);
        } else {
            self.contentView.frame = contentViewFrame;
            [self.contentView setNeedsLayout];
            [self.contentView layoutIfNeeded];
            
            [self showingAnimationWithCompletion:didShownCompletion];
        }
    } else {
        CGRect contentViewFrame = [self contentViewFrameForShowing];
        self.contentView.frame = contentViewFrame;
        [self.view addSubview:self.contentView];
        self.dimmingView.alpha = 1;
        didShownCompletion(YES);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.hasAlreadyViewWillDisappear) {
        return;
    }
    
    [super viewWillDisappear:animated];
    if (self.containerWindow) {
        animated = self.disappearAnimated;
    }
    void (^didHiddenCompletion)(BOOL finished) = ^(BOOL finished) {
        
        if (self.containerWindow) {
            self.containerWindow.hidden = YES;
            self.containerWindow.rootViewController = nil;
            [self endAppearanceTransition];
        }
        
        if (self.view.superview) {
            // 这句是给addSubview的形式显示的情况下使用，但会触发第二次viewWillDisappear:，所以要搭配self.hasAlreadyViewWillDisappear使用
            [self.view removeFromSuperview];
            self.hasAlreadyViewWillDisappear = NO;
        }
        
        [self.contentView removeFromSuperview];
        self.contentView = nil;
        if (self.contentViewController) {
            [self.contentViewController endAppearanceTransition];
        }
        
        _visible = NO;
        
        if ([self.delegate respondsToSelector:@selector(didHideModalPresentationViewController:)]) {
            [self.delegate didHideModalPresentationViewController:self];
        }
        
        if (self.disappearCompletionBlock) {
            self.disappearCompletionBlock(YES);
            self.disappearCompletionBlock = nil;
        }
        
        if (self.contentViewController) {
            self.contentViewController.modalPresentedViewController = nil;
            self.contentViewController = nil;
        }
        
        self.disappearAnimated = NO;
    };
    
    // 在降下键盘前取消对键盘事件的监听，从而避免键盘影响隐藏浮层的动画
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self resetDimmedApplicationWindow];
    [self.view endEditing:YES];
    
    if (self.contentViewController) {
        [self.contentViewController beginAppearanceTransition:NO animated:animated];
    }
    
    if (animated) {
        if (self.hidingAnimation) {
            self.hidingAnimation(self.dimmingView, self.view.bounds, self.keyboardHeight, didHiddenCompletion);
        } else {
            [self hidingAnimationWithCompletion:didHiddenCompletion];
        }
    } else {
        didHiddenCompletion(YES);
    }
}

#pragma mark - Dimming View

- (void)setDimmingView:(UIView *)dimmingView {
    if (![self isViewLoaded]) {
        _dimmingView = dimmingView;
    } else {
        [self.view insertSubview:dimmingView belowSubview:_dimmingView];
        [_dimmingView removeFromSuperview];
        _dimmingView = dimmingView;
        [self.view setNeedsLayout];
    }
    [self addTapGestureRecognizerToDimmingViewIfNeeded];
}

- (void)initDefaultDimmingViewWithoutAddToView {
    if (!self.dimmingView) {
        _dimmingView = [[UIView alloc] init];
        self.dimmingView.alpha = 0.0;
        self.dimmingView.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .35f);
        [self addTapGestureRecognizerToDimmingViewIfNeeded];
        if ([self isViewLoaded]) {
            [self.view addSubview:self.dimmingView];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"");
}

// 要考虑用户可能创建了自己的dimmingView，则tap手势也要重新添加上去
- (void)addTapGestureRecognizerToDimmingViewIfNeeded {
    if (!self.dimmingView) {
        return;
    }
    
    if (self.dimmingViewTapGestureRecognizer.view == self.dimmingView) {
        return;
    }
    
    if (!self.dimmingViewTapGestureRecognizer) {
        self.dimmingViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDimmingViewTapGestureRecognizer:)];
    }
    [self.dimmingView addGestureRecognizer:self.dimmingViewTapGestureRecognizer];
    self.dimmingView.userInteractionEnabled = YES;// UIImageView默认userInteractionEnabled为NO，为了兼容UIImageView，这里必须主动设置为YES
}

- (void)handleDimmingViewTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.modal) {
        return;
    }
    
    if (self.containerWindow) {
        // 认为是以 UIWindow 的形式显示出来
        __weak __typeof(self)weakSelf = self;
        [self hideWithAnimated:YES completion:^(BOOL finished) {
            if (weakSelf.didHideByDimmingViewTappedBlock) {
                weakSelf.didHideByDimmingViewTappedBlock();
            }
        }];
    } else if (self.presentingViewController && self.presentingViewController.presentedViewController == self) {
        // 认为是以 presentViewController 的形式显示出来
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.didHideByDimmingViewTappedBlock) {
                self.didHideByDimmingViewTappedBlock();
            }
        }];
    } else {
        // 认为是 addSubview 的形式显示出来
        __weak __typeof(self)weakSelf = self;
        [self hideInView:self.view.superview animated:YES completion:^(BOOL finished) {
            if (weakSelf.didHideByDimmingViewTappedBlock) {
                weakSelf.didHideByDimmingViewTappedBlock();
            }
        }];
    }
}

#pragma mark - ContentView

- (void)setContentViewController:(UIViewController<ModalPresentationContentViewProtocol> *)contentViewController {
    _contentViewController = contentViewController;
    self.contentView = contentViewController.view;
}

#pragma mark - Showing and Hiding

- (void)showingAnimationWithCompletion:(void (^)(BOOL))completion {
    if (self.animationStyle == ModalPresentationAnimationStyleFade) {
        self.dimmingView.alpha = 0.0;
        self.contentView.alpha = 0.0;
        [UIView animateWithDuration:.2 delay:0.0 options:ViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 1.0;
            self.contentView.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
        
    } else if (self.animationStyle == ModalPresentationAnimationStylePopup) {
        self.dimmingView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:.3 delay:0.0 options:ViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            self.contentView.transform = CGAffineTransformIdentity;
            if (completion) {
                completion(finished);
            }
        }];
        
    } else if (self.animationStyle == ModalPresentationAnimationStyleSlide) {
        self.dimmingView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.contentView.frame));
        [UIView animateWithDuration:.3 delay:0.0 options:ViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 1.0;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)showWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    // makeKeyAndVisible导致的viewWillAppear:必定animated是NO的，所以这里用额外的变量保存这个animated的值
    self.appearAnimated = animated;
    self.appearCompletionBlock = completion;
    
    if (!self.containerWindow) {
        self.containerWindow = [[ModalPresentationWindow alloc] init];
        self.containerWindow.windowLevel = UIWindowLevelAlert - 4.0;
        self.containerWindow.backgroundColor = [UIColor clearColor];// 避免横竖屏旋转时出现黑色
    }
    self.containerWindow.rootViewController = self;
    self.containerWindow.hidden = NO;
}

- (void)hideWithAnimated:(BOOL)animated completion:(void (^)(BOOL))completion{
    self.disappearAnimated = animated;
    self.disappearCompletionBlock = completion;
    
    BOOL shouldHide = YES;
    if ([self.delegate respondsToSelector:@selector(shouldHideModalPresentationViewController:)]) {
        shouldHide = [self.delegate shouldHideModalPresentationViewController:self];
    }
    if (!shouldHide) {
        return;
    }
    // window模式下，通过手动触发viewWillDisappear:来做界面消失的逻辑
    if (self.containerWindow) {
        [self beginAppearanceTransition:NO animated:animated];
    }
}

- (void)hidingAnimationWithCompletion:(void (^)(BOOL))completion {
    if (self.animationStyle == ModalPresentationAnimationStyleFade) {
        [UIView animateWithDuration:.2 delay:0.0 options:ViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 0.0;
            self.contentView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else if (self.animationStyle == ModalPresentationAnimationStylePopup) {
        [UIView animateWithDuration:.3 delay:0.0 options:ViewAnimationOptionsCurveOut animations:^{
            self.dimmingView.alpha = 0.0;
            // 运行时报警告：CGAffineTransformInvert: singular matrix.
            CGAffineTransform newTransform =  CGAffineTransformMakeScale(0.0000f, 0.00000f);
            self.contentView.transform = newTransform;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else if (self.animationStyle == ModalPresentationAnimationStyleSlide) {
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.dimmingView.alpha = 0.0;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.contentView.frame));
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self.appearCompletionBlock = completion;
    [self loadViewIfNeeded];
    [self beginAppearanceTransition:YES animated:animated];
    [view addSubview:self.view];
    [self endAppearanceTransition];
}

- (void)hideInView:(UIView *)view animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self.disappearCompletionBlock = completion;
    [self beginAppearanceTransition:NO animated:animated];
    self.hasAlreadyViewWillDisappear = YES;
    [self endAppearanceTransition];
}

- (CGRect)contentViewFrameForShowing{
    CGSize contentViewContainerSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentViewMargins), CGRectGetHeight(self.view.bounds) - self.keyboardHeight - UIEdgeInsetsGetVerticalValue(self.contentViewMargins));
    CGSize contentViewLimitSize = CGSizeMake(fminf(self.maximumContentViewWidth, contentViewContainerSize.width), contentViewContainerSize.height);
    CGSize contentViewSize = CGSizeZero;
    if ([self.contentViewController respondsToSelector:@selector(preferredContentSizeInModalPresentationVC:limitSize:)]) {
        contentViewSize = [self.contentViewController preferredContentSizeInModalPresentationVC:self limitSize:contentViewLimitSize];
    } else {
        contentViewSize = [self.contentView sizeThatFits:contentViewLimitSize];
    }
    contentViewSize.width = fminf(contentViewLimitSize.width, contentViewSize.width);
    contentViewSize.height = fminf(contentViewLimitSize.height, contentViewSize.height);
    CGRect contentViewFrame = CGRectMake(CGFloatGetCenter(contentViewContainerSize.width, contentViewSize.width) + self.contentViewMargins.left, CGFloatGetCenter(contentViewContainerSize.height, contentViewSize.height) + self.contentViewMargins.top, contentViewSize.width, contentViewSize.height);
    
    // showingAnimation、hidingAnimation里会通过设置contentView的transform来做动画，所以可能在showing的过程中设置了transform后，系统触发viewDidLayoutSubviews，在viewDidLayoutSubviews里计算的frame又是最终状态的frame，与showing时的transform冲突，导致动画过程中浮层跳动或者位置错误，所以为了保证layout时计算出来的frame与showing/hiding时计算的frame一致，这里给frame应用了transform。但这种处理方法也有局限：如果你在showingAnimation/hidingAnimation里对contentView.frame的更改不是通过修改transform而是直接修改frame来得到结果，那么这里这句CGRectApplyAffineTransform就没用了，viewDidLayoutSubviews里算出来的frame依然会和showingAnimation/hidingAnimation冲突。
    contentViewFrame = CGRectApplyAffineTransform(contentViewFrame, self.contentView.transform);
    return contentViewFrame;
}

#pragma mark - Keyboard

- (void)handleKeyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [self keyboardHeightWithNotification:notification inView:self.view];
    if (keyboardHeight > 0) {
        self.keyboardHeight = keyboardHeight;
        [self.view setNeedsLayout];
    }
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    self.keyboardHeight = 0;
    [self.view setNeedsLayout];
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    UIViewController *visibleViewController = [self visibleViewController];
    if (visibleViewController != self && [visibleViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [visibleViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *visibleViewController = [self visibleViewController];
    if (visibleViewController != self && [visibleViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [visibleViewController supportedInterfaceOrientations];
    }
    return self.supportedOrientationMask;
}

- (CGRect)keyboardRectWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 注意iOS8以下的系统在横屏时得到的rect，宽度和高度相反了，所以不建议直接通过这个方法获取高度，而是使用<code>keyboardHeightWithNotification:inView:</code>，因为在后者的实现里会将键盘的rect转换坐标系，转换过程就会处理横竖屏旋转问题。
    return keyboardRect;
}

- (CGFloat)keyboardHeightWithNotification:(nullable NSNotification *)notification inView:(nullable UIView *)view {
    CGRect keyboardRect = [self keyboardRectWithNotification:notification];
    if (!view) {
        return CGRectGetHeight(keyboardRect);
    }
    CGRect keyboardRectInView = [view convertRect:keyboardRect fromView:view.window];
    CGRect keyboardVisibleRectInView = CGRectIntersection(view.bounds, keyboardRectInView);
    CGFloat resultHeight = CGRectIsNull(keyboardVisibleRectInView) ? 0.0f : CGRectGetHeight(keyboardVisibleRectInView);
    return resultHeight;
}

- (nullable UIViewController *)visibleViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *visibleViewController = [rootViewController visibleViewControllerIfExist];
    return visibleViewController;
}

- (void)resetDimmedApplicationWindow {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [window tintColorDidChange];
}

- (void)dimmedApplicationWindow {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [window tintColorDidChange];
}

@end



@implementation ModalPresentationWindow

@end

@implementation UIViewController (Helper)

- (UIViewController *)visibleViewControllerIfExist{
    if (self.presentedViewController) {
        return [self.presentedViewController visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).topViewController visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController visibleViewControllerIfExist];
    }
    
    if ([self isViewLoaded] && self.view.window) {
        return self;
    } else {
        NSLog(@"visibleViewControllerIfExist:，找不到可见的viewController。self = %@, self.view.window = %@", self, self.view.window);
        return nil;
    }
}

@end

@implementation UIViewController (ModalPresentationViewController)

static char kAssociatedObjectKey_ModalPresentationViewController;

- (void)setModalPresentedViewController:(ModalPresentationViewController *)modalPresentedViewController {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_ModalPresentationViewController, modalPresentedViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (ModalPresentationViewController *)modalPresentedViewController {
    return (ModalPresentationViewController *)objc_getAssociatedObject(self, &kAssociatedObjectKey_ModalPresentationViewController);
}


@end
