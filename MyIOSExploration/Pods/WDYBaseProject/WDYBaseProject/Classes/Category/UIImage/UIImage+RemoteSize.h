
//https://github.com/AYastrebov/UIImage-RemoteSize

#import <UIKit/UIKit.h>

typedef void (^UIImageSizeRequestCompleted) (NSURL* imgURL, CGSize size);

@interface UIImage (RemoteSize)

/** 请求远端图片的size */
+ (void)requestSizeFor:(NSURL*)imgURL completion:(UIImageSizeRequestCompleted)completion;

@end
