//
//  UIView+SubImage.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (SubImage)
/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定像素 */
- (UIImage *)scaledImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

/** 将两个图片生成一张图片 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/** 返回一张自由拉伸的图片 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/** 压缩图片至指定尺寸 */
- (UIImage*)scaledToSize:(CGSize)targetSize;

/** 压缩图片至指定尺寸, 是否高质量压缩 */
- (UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

/** 压缩图片，最大尺寸 */
- (UIImage*)scaledToMaxSize:(CGSize )size;
@end
