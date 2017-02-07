//
//  NewFeaturePagesView.h
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

@interface NewFeaturePagesView : UIView

-(instancetype)initPagesViewWithFrame:(CGRect)frame Images:(NSArray *)images;
@end
