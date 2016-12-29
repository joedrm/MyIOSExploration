//
//  UIViewController+BackButtonHandler.h
//  Pods
//
//  Created by fang wang on 16/12/29.
//
// 主要用于拦截返回按钮的点击

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
