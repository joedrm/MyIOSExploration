
// https://github.com/Just-/UINavigationItem-Loading

#import <UIKit/UIKit.h>

/** 在navigationbar上显示UIActivityIndicatorView的位置*/
typedef NS_ENUM(NSUInteger, NavBarLoaderPosition)
{
    NavBarLoaderPositionCenter = 0,

    NavBarLoaderPositionLeft,

    NavBarLoaderPositionRight
};

@interface UINavigationItem (Loading)

/** 开始在position位置显示UIActivityIndicatorView */
- (void)startAnimatingAt:(NavBarLoaderPosition)position;

/** 结束显示UIActivityIndicatorView*/
- (void)stopAnimating;

@end
