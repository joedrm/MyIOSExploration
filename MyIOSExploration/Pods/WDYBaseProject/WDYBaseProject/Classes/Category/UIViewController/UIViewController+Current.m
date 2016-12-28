
#import "UIViewController+Current.h"

@implementation UIViewController (Current)

+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController)
    {
        return [self findBestViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UISplitViewController class]])
    {
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
        {
            return [self findBestViewController:svc.viewControllers.lastObject];
        }
        else
        {
            return vc;
        }
        
    }
    else if ([vc isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
        {
            return [self findBestViewController:svc.topViewController];
        }
        else
        {
            return vc;
        }
        
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
        {
            return [self findBestViewController:svc.selectedViewController];
        }
        else
        {
            return vc;
        }
        
    }
    else
    {
        return vc;
    }
}

+ (UIViewController *)currentViewController
{
    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    return [UIViewController findBestViewController:viewController];
}

+ (UINavigationController *)currentNavigatonController {
    
    UIViewController * currentViewController =  [UIViewController currentViewController];
    
    return currentViewController.navigationController;
}

@end
