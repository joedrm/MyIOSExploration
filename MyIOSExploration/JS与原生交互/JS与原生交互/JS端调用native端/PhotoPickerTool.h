//
//  JJPhotoHelper.h
//  ChatChat
//
//  Created by namebryant on 14-9-25.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
typedef void(^DidFinishTakeMediaCompledBlock)(UIImage *image, NSDictionary *editingInfo);
@interface PhotoPickerTool : NSObject
single_interface(PhotoPickerTool)

/**
 *  选择图片选择器
 *
 *  @param sourceType     来源
 *  @param viewController 控制器
 *  @param compled        回调
 */
- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled;
@end
