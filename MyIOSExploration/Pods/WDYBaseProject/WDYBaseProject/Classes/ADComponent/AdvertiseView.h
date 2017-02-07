//
//  AdvertiseView.h
//  Pods
//
//  Created by fang wang on 17/1/9.
//
//

#import <UIKit/UIKit.h>

#define kScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)
#define kAdUserDefaults [NSUserDefaults standardUserDefaults]
#define kScreenBounds [[UIScreen mainScreen] bounds]

static NSString* const NotificationContants_Advertise_Key=@"AdvertisePush";
static NSString *const adImageName = @"adImageName";

@interface AdvertiseView : UIView
/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;
@end
