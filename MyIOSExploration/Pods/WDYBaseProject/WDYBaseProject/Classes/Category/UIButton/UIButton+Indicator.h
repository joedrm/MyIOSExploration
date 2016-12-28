
#import <UIKit/UIKit.h>

/** 提交按钮 提交时在中间显示一个菊花 */

@interface UIButton (Indicator)

/** 显示菊花 */
- (void)showIndicator;

/** 隐藏菊花 */
- (void)hideIndicator;

@end
