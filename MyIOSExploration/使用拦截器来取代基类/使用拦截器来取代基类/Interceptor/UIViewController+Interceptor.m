//
//  UIViewController+Interceptor.m
//  使用拦截器来取代基类
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "UIViewController+Interceptor.h"
#import <objc/runtime.h>

static NSString* KeyIsInitTheme = @"KeyIsInitTheme";
static NSString* KeyDisabledInterceptor = @"KeyDisabledInterceptor";

@implementation UIViewController (Interceptor)

- (BOOL)isInitTheme {
    return objc_getAssociatedObject(self, (__bridge const void *)(KeyIsInitTheme));
}

- (void)setIsInitTheme:(BOOL)isInitTheme {
    objc_setAssociatedObject(self, (__bridge const void *)(KeyIsInitTheme), @(isInitTheme), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disabledInterceptor {
    return objc_getAssociatedObject(self, (__bridge const void *)(KeyDisabledInterceptor));
}

- (void)setDisabledInterceptor:(BOOL)disabledInterceptor {
    NSNumber *integer = @(disabledInterceptor);
    if (integer.intValue == 0) {
        objc_setAssociatedObject(self, (__bridge const void *)(KeyDisabledInterceptor), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, (__bridge const void *)(KeyDisabledInterceptor), integer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
