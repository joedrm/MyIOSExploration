//
//  ImagePickerCtrHelper.m
//  Pods
//
//  Created by fang wang on 17/1/19.
//
//

#import "ImagePickerCtrHelper.h"
#import "DeviceAuthorizationHelper.h"

@interface ImagePickerCtrHelper ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) ImagePickerType sourceType;
@property (nonatomic, copy) ImagePickerCtrHelperBlock block;
@property (nonatomic, strong) UIImagePickerController *ipc;

@end

@implementation ImagePickerCtrHelper

SingletonM(Instance)

- (UIImagePickerController *)ipc{
    if (!(_ipc)) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.delegate = self;
        _ipc.allowsEditing = YES;
        _ipc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return _ipc;
}

- (void)showWithSourceType:(ImagePickerType)sourceType onViewController:(UIViewController *)vc block:(ImagePickerCtrHelperBlock)block{
    if (vc && sourceType && block) {
        self.vc = vc;
        self.sourceType = sourceType;
        self.block = block;
    }
    
    if (self.sourceType == ImagePickerType_camera) {
        self.ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (self.sourceType == ImagePickerType_photoLibrary ){
        self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    __weak typeof(self) weakSelf = self;
    [DeviceAuthorizationHelper cameraAuthorization:^(BOOL bRet) {
        if (bRet) {
            double delayInSeconds = 0.1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [vc presentViewController:weakSelf.ipc animated:YES completion:nil];
            });
        }else{
            if (block) {
                block(nil);
            }
        }
    }];
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.block) {
        self.block(image);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    if (self.block) {
        self.block(nil);
    }
}


@end
