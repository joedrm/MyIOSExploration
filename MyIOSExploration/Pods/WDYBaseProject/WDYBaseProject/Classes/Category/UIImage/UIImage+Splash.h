//
//  UIImage+Splash.h
//  Pods
//
//  Created by fang wang on 17/1/19.
//
//

/** 获取启动页图片的分类 */

#import <UIKit/UIKit.h>

@interface UIImage (Splash)

+ (UIImage *)splashImage;

+ (UIImage *)splashImageForInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
