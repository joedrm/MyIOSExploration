//
//  UIImageView+Blur.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import <UIKit/UIKit.h>
typedef void(^WDYBlurredImageCompletionBlock)(void);

extern CGFloat const kWDYBlurredImageDefaultBlurRadius;
@interface UIImageView (Blur)

// ------ 设置半透明模糊效果
- (void)setImageToBlur:(UIImage *)image blurRadius:(CGFloat)blurRadius completionBlock:(WDYBlurredImageCompletionBlock)completion;
- (void)setImageToBlur:(UIImage *)image completionBlock:(WDYBlurredImageCompletionBlock)completion;


@end
