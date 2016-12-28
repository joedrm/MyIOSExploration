//
//  UIImageView+AnimForSDWebImage.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//


// 由于 SDWebImage 与项目中的其它版本SDWebImage起冲突，所以单独放在这里，pod导入时，可以分文件导入

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageCompat.h>
#import <SDWebImage/SDWebImageManager.h>

@interface UIImageView (AnimForSDWebImage)

NS_ASSUME_NONNULL_BEGIN

- (NSURL *)sd_imageURL;

- (void)sd_setImageWithURL:(NSURL *)url fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDWebImageCompletionBlock)completedBlock fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock fadeAnimation:(BOOL)fadeAnimation;

- (void)sd_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs;

- (void)sd_cancelCurrentImageLoad;

- (void)sd_cancelCurrentAnimationImagesLoad;

NS_ASSUME_NONNULL_END
@end
