//
//  YYAnimatedImageView.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 14/10/19.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An image view for displaying animated image.
 
 @discussion It is a fully compatible `UIImageView` subclass.
 If the `image` or `highlightedImage` property adopt to the `YYAnimatedImage` protocol,
 then it can be used to play the multi-frame animation. The animation can also be 
 controlled with the UIImageView methods `-startAnimating`, `-stopAnimating` and `-isAnimating`.
 
 This view request the frame data just in time. When the device has enough free memory, 
 this view may cache some or all future frames in an inner buffer for lower CPU cost.
 Buffer size is dynamically adjusted based on the current state of the device memory.
 
 Sample Code:
 
     // ani@3x.gif
     YYImage *image = [YYImage imageNamed:@"ani"];
     YYAnimatedImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface YYAnimatedImageView : UIImageView

// View显示完毕 且帧数大于等于1 可是设置 自动播放功能，默认是 YES
@property (nonatomic) BOOL autoPlayAnimatedImage;

/**
 Index of the currently displayed frame (index from 0).
 
 Set a new value to this property will cause to display the new frame immediately.
 If the new value is invalid, this method has no effect.
 
 You can add an observer to this property to observe the playing status.
 */
// 当前显示的帧的索引
@property (nonatomic) NSUInteger currentAnimatedImageIndex;

/**
 Whether the image view is playing animation currently.
 
 You can add an observer to this property to observe the playing status.
 */
@property (nonatomic, readonly) BOOL currentIsPlayingAnimation;

/**
 The animation timer's runloop mode, default is `NSRunLoopCommonModes`.
 
 Set this property to `NSDefaultRunLoopMode` will make the animation pause during
 UIScrollView scrolling.
 */
@property (nonatomic, copy) NSString *runloopMode;

/**
 The max size (in bytes) for inner frame buffer size, default is 0 (dynamically).
 
 When the device has enough free memory, this view will request and decode some or 
 all future frame image into an inner buffer. If this property's value is 0, then 
 the max buffer size will be dynamically adjusted based on the current state of 
 the device free memory. Otherwise, the buffer size will be limited by this value.
 
 When receive memory warning or app enter background, the buffer will be released 
 immediately, and may grow back at the right time.
 */
@property (nonatomic) NSUInteger maxBufferSize;

@end



/**
 The YYAnimatedImage protocol declares the required methods for animated image
 display with YYAnimatedImageView.
 
 Subclass a UIImage and implement this protocol, so that instances of that class 
 can be set to YYAnimatedImageView.image or YYAnimatedImageView.highlightedImage
 to display animation.
 
 See `YYImage` and `YYFrameImage` for example.
 */
@protocol YYAnimatedImage <NSObject>
@required

// 动图的帧数
- (NSUInteger)animatedImageFrameCount;

// 动图的循环(播放)次数，0 表示无穷大
- (NSUInteger)animatedImageLoopCount;

// 每一帧在内存中占得字节数，用于缓存空间优化
- (NSUInteger)animatedImageBytesPerFrame;

// 返回 index 位置的帧图片，此方法被后台线程调用
- (nullable UIImage *)animatedImageFrameAtIndex:(NSUInteger)index;

// 返回 index 位置的动图播放时间
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;

@optional
/// A rectangle in image coordinates defining the subrectangle of the image that
/// will be displayed. The rectangle should not outside the image's bounds.
/// It may used to display sprite animation with a single image (sprite sheet).
// 返回 index 位置的动图显示的Rect值
- (CGRect)animatedImageContentsRectAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
