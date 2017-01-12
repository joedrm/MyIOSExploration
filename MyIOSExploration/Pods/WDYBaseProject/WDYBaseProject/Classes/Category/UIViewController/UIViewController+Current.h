
#import <UIKit/UIKit.h>

@interface UIViewController (Current)

//找到当前视图控制器
+ (UIViewController *)currentViewController;

//找到当前导航控制器
+ (UINavigationController *)currentNavigatonController;

@end
