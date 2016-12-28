//
//  UIImage+Crop.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)
+ (UIImage*) circleImage:(UIImage*) image borderWidth:(CGFloat) borderWidth borderColor:(UIColor*) borderColor;

/**
 * 返回一张圆形图片
 */
- (UIImage*)circleImage;
+ (UIImage*)circleImageNamed:(NSString *)name;
@end
