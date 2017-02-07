//
//  NSBundle+MyLibrary.m
//  Pods
//
//  Created by fang wang on 17/1/9.
//
//

#import "NSBundle+MyLibrary.h"

@implementation NSBundle (MyLibrary)

+ (instancetype)resourceBundleWithClass:(Class)nameClass
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:nameClass] pathForResource:@"WDYBaseProject" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)tips_doneImageClass:(Class)nameClass
{
    static UIImage *tips_doneImage = nil;
    if (tips_doneImage == nil) {
        tips_doneImage = [[UIImage imageWithContentsOfFile:[[self resourceBundleWithClass:nameClass] pathForResource:@"tips_done@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return tips_doneImage;
}

+ (UIImage *)tips_errorImageClass:(Class)nameClass{
    static UIImage *errorImage = nil;
    if (errorImage == nil) {
        errorImage = [[UIImage imageWithContentsOfFile:[[self resourceBundleWithClass:nameClass] pathForResource:@"tips_error@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return errorImage;
}

+ (UIImage *)tips_infoImageClass:(Class)nameClass{
    static UIImage *infoImage = nil;
    if (infoImage == nil) {
        infoImage = [[UIImage imageWithContentsOfFile:[[self resourceBundleWithClass:nameClass] pathForResource:@"tips_info@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return infoImage;
}

@end
