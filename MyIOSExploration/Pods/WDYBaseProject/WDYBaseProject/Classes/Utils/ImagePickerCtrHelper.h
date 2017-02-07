//
//  ImagePickerCtrHelper.h
//  Pods
//
//  Created by fang wang on 17/1/19.
//
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef NS_ENUM(NSInteger, ImagePickerType) {
    ImagePickerType_camera = 1,
    ImagePickerType_photoLibrary,
};

typedef void (^ImagePickerCtrHelperBlock)(id result);

@interface ImagePickerCtrHelper : NSObject

SingletonH(Instance)

- (void)showWithSourceType:(ImagePickerType)sourceType onViewController:(UIViewController *)vc block:(ImagePickerCtrHelperBlock)block;


@end
