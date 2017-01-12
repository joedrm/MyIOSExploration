//
//  UIImage+AlphaMask.h
//  Quartz 2D实践
//
//  Created by fang wang on 16/12/12.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AlphaMask)
+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage*) mask2Image:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage*) mask3Image:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage *)mask4Image:(UIImage *)image withMask:(UIImage *)maskImage;

+ (UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage;
+ (UIImage*) mask5Image:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage*) doImageMask:(UIImage *)mainImage maskImage:(UIImage*)maskImage;
//黑色替换成对应颜色
- (UIImage*)imageBlackToTransparentWithColor:(UIColor *)color;

- (UIImage *)inverseMaskImage;
@end
