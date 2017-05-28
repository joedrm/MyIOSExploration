//
//  Student.m
//  hello
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "Student.h"
#import "PhotoPickerTool.h"
#import "JSToNativeViewController.h"

@implementation Student

- (void)takePhoto{
    NSLog(@"add a student");
    [[PhotoPickerTool sharedPhotoPickerTool] showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceTypeSavedPhotosAlbum) onViewController:self.viewController compled:^(UIImage *image, NSDictionary *editingInfo) {
        NSLog(@"make photo");
        JSToNativeViewController * VC =  (JSToNativeViewController *)(self.viewController);
        VC.summerImageView.image = image;
    }];
}

@end
