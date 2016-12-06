//
//  UIViewController+Interceptor.h
//  使用拦截器来取代基类
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Interceptor)

// 拦截器是否有效
@property(nonatomic, assign) BOOL disabledInterceptor;
@property(nonatomic, assign) BOOL isInitTheme;
@end
