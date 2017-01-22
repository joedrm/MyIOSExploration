//
//  AppCommonHelper.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AppCommonHelper.h"
#import "CommonDefines.h"
#import <objc/runtime.h>

@implementation AppCommonHelper (Keyboard)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance] selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance] selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    });
}

- (void)handleKeyboardWillShow:(NSNotification *)notification {
    self.keyboardVisible = YES;
    self.lastKeyboardHeight = [AppCommonHelper keyboardHeightWithNotification:notification];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    self.keyboardVisible = NO;
}

static char kAssociatedObjectKey_KeyboardVisible;
- (void)setKeyboardVisible:(BOOL)argv {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_KeyboardVisible, @(argv), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isKeyboardVisible {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_KeyboardVisible)) boolValue];
}

+ (BOOL)isKeyboardVisible {
    BOOL visible = [[AppCommonHelper sharedInstance] isKeyboardVisible];
    return visible;
}

static char kAssociatedObjectKey_LastKeyboardHeight;
- (void)setLastKeyboardHeight:(CGFloat)argv {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_LastKeyboardHeight, @(argv), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)lastKeyboardHeight {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_LastKeyboardHeight)) floatValue];
}

+ (CGFloat)lastKeyboardHeightInApplicationWindowWhenVisible {
    return [[AppCommonHelper sharedInstance] lastKeyboardHeight];
}

+ (CGRect)keyboardRectWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 注意iOS8以下的系统在横屏时得到的rect，宽度和高度相反了，所以不建议直接通过这个方法获取高度，而是使用<code>keyboardHeightWithNotification:inView:</code>，因为在后者的实现里会将键盘的rect转换坐标系，转换过程就会处理横竖屏旋转问题。
    return keyboardRect;
}

+ (CGFloat)keyboardHeightWithNotification:(NSNotification *)notification {
    return [AppCommonHelper keyboardHeightWithNotification:notification inView:nil];
}

+ (CGFloat)keyboardHeightWithNotification:(nullable NSNotification *)notification inView:(nullable UIView *)view {
    CGRect keyboardRect = [self keyboardRectWithNotification:notification];
    if (!view) {
        return CGRectGetHeight(keyboardRect);
    }
    CGRect keyboardRectInView = [view convertRect:keyboardRect fromView:view.window];
    CGRect keyboardVisibleRectInView = CGRectIntersection(view.bounds, keyboardRectInView);
    CGFloat resultHeight = CGRectIsNull(keyboardVisibleRectInView) ? 0.0f : CGRectGetHeight(keyboardVisibleRectInView);
    return resultHeight;
}

+ (NSTimeInterval)keyboardAnimationDurationWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    return animationDuration;
}

+ (UIViewAnimationCurve)keyboardAnimationCurveWithNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    return curve;
}

+ (UIViewAnimationOptions)keyboardAnimationOptionsWithNotification:(NSNotification *)notification {
    UIViewAnimationOptions options = [AppCommonHelper keyboardAnimationCurveWithNotification:notification]<<16;
    return options;
}

@end






@implementation AppCommonHelper (Device)

static NSInteger isIPad = -1;
+ (BOOL)isIPad {
    if (isIPad < 0) {
        // [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] 无法判断模拟器，改为以下方式
        isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0;
    }
    return isIPad > 0;
}

static NSInteger isIPadPro = -1;
+ (BOOL)isIPadPro {
    if (isIPadPro < 0) {
        isIPadPro = [AppCommonHelper isIPad] ? (DEVICE_WIDTH == 1024 && DEVICE_HEIGHT == 1366 ? 1 : 0) : 0;
    }
    return isIPadPro > 0;
}

static NSInteger isIPod = -1;
+ (BOOL)isIPod {
    if (isIPod < 0) {
        isIPod = [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"] ? 1 : 0;
    }
    return isIPod > 0;
}

static NSInteger isIPhone = -1;
+ (BOOL)isIPhone {
    if (isIPhone < 0) {
        isIPhone = [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] ? 1 : 0;
    }
    return isIPhone > 0;
}

static NSInteger isSimulator = -1;
+ (BOOL)isSimulator {
    if (isSimulator < 0) {
#if TARGET_OS_SIMULATOR
        isSimulator = 1;
#else
        isSimulator = 0;
#endif
    }
    return isSimulator > 0;
}

static NSInteger is55InchScreen = -1;
+ (BOOL)is55InchScreen {
    if (is55InchScreen < 0) {
        is55InchScreen = (DEVICE_WIDTH == self.screenSizeFor55Inch.width && DEVICE_HEIGHT == self.screenSizeFor55Inch.height) ? 1 : 0;
    }
    return is55InchScreen > 0;
}

static NSInteger is47InchScreen = -1;
+ (BOOL)is47InchScreen {
    if (is47InchScreen < 0) {
        is47InchScreen = (DEVICE_WIDTH == self.screenSizeFor47Inch.width && DEVICE_HEIGHT == self.screenSizeFor47Inch.height) ? 1 : 0;
    }
    return is47InchScreen > 0;
}

static NSInteger is40InchScreen = -1;
+ (BOOL)is40InchScreen {
    if (is40InchScreen < 0) {
        is40InchScreen = (DEVICE_WIDTH == self.screenSizeFor40Inch.width && DEVICE_HEIGHT == self.screenSizeFor40Inch.height) ? 1 : 0;
    }
    return is40InchScreen > 0;
}

static NSInteger is35InchScreen = -1;
+ (BOOL)is35InchScreen {
    if (is35InchScreen < 0) {
        is35InchScreen = (DEVICE_WIDTH == self.screenSizeFor35Inch.width && DEVICE_HEIGHT == self.screenSizeFor35Inch.height) ? 1 : 0;
    }
    return is35InchScreen > 0;
}

+ (CGSize)screenSizeFor55Inch {
    return CGSizeMake(414, 736);
}

+ (CGSize)screenSizeFor47Inch {
    return CGSizeMake(375, 667);
}

+ (CGSize)screenSizeFor40Inch {
    return CGSizeMake(320, 568);
}

+ (CGSize)screenSizeFor35Inch {
    return CGSizeMake(320, 480);
}

//static NSInteger isHighPerformanceDevice = -1;
//+ (BOOL)isHighPerformanceDevice {
//    if (isHighPerformanceDevice < 0) {
//        isHighPerformanceDevice = (IOS_VERSION >= 8.0 && PreferredVarForUniversalDevices(YES, YES, YES, NO, NO)) ? 1 : 0;
//    }
//    return isHighPerformanceDevice > 0;
//}

@end





@implementation AppCommonHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AppCommonHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        // 先设置默认值，不然可能变量的指针地址错误
        instance.keyboardVisible = NO;
        instance.lastKeyboardHeight = 0;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)dealloc {
    // QMUIHelper (Keyboard)里用到消息监听，所以在dealloc的时候注销一下
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
