//
//  UINavigationController+StackManager.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (StackManager)
/** 寻找Navigation中的某个viewcontroler */
- (id)findViewController:(Class)className;

/** 判断是否只有一个RootViewController */
- (BOOL)isOnlyContainRootViewController;

/** RootViewController */
- (UIViewController *)rootViewController;

/** 返回指定的viewcontroler */
- (NSArray *)popToViewControllerWithClassName:(Class)className animated:(BOOL)animated;

/** pop回第n层 */
- (NSArray *)popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;
@end
