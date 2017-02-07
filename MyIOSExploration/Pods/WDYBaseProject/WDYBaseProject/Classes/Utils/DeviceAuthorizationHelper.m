//
//  CameraAuthorizeHelper.m
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import "DeviceAuthorizationHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <EventKit/EventKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "DeviceHelper.h"
#import "AlertViewHelper.h"

@import AVFoundation;

@implementation DeviceAuthorizationHelper

#pragma mark - ***** 相机授权 ******
+ (void)cameraAuthorization:(AuthorizationBlock)block{
    if ([DeviceHelper isSystemIos7Later]) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined:{   //未授权 发起授权
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (block) {
                        block(granted);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized:{   // 已经开启授权，可继续
                if (block) {
                    block(YES);
                }
                break;
            }
            case AVAuthorizationStatusDenied:{       //拒绝
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                NSString *msg = [NSString stringWithFormat:@"该功能需您请前往 “设置->隐私->相机->%@“ 开启权限", appName];
                [AlertViewHelper alertWithTitle:@"提示" message:msg cancelButtonTitle:@"我知道了" confirmButtonTitle:nil block:nil];
                if (block) {
                    block(NO);
                }
            }
                break;
            case AVAuthorizationStatusRestricted:   //没有权限访问
                if (block) {
                    block(NO);
                }
                break;
            default:
                break;
        }
    }else{
        block(YES);
    }
}

/** 判断设备是否有摄像头 */
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/** 前面的摄像头是否可用 */
- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/** 后面的摄像头是否可用 */
- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - ***** 定位授权 ******
+ (void)locationAuthorization:(AuthorizationBlock)block{
    if ([CLLocationManager locationServicesEnabled]){   //检测的是整个的iOS系统的定位服务是否开启
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        switch (authStatus) {
            case kCLAuthorizationStatusNotDetermined:{   //未选择
                CLLocationManager* location = [[CLLocationManager alloc] init];
                if ([location respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [location requestWhenInUseAuthorization];
                }
            }
                break;
            case kCLAuthorizationStatusRestricted:      //无权限
                block(NO);
                break;
            case kCLAuthorizationStatusDenied:          //拒绝
                block(NO);
                break;
            case kCLAuthorizationStatusAuthorizedAlways:    //允许 任何时候
            case kCLAuthorizationStatusAuthorizedWhenInUse: //允许 使用的时候
                block(YES);
                break;
            default:
                break;
        }
    }else{
        block(NO);
    }
}

#pragma mark - ***** 照片库授权 ******
+ (void)assetsLibAuthorization:(AuthorizationBlock)block{
    NSInteger author;
    if ([DeviceHelper isSystemIos8Later]) {
        author = [PHPhotoLibrary authorizationStatus];
    }else{
        author = [ALAssetsLibrary authorizationStatus];
    }
    switch (author) {
        case PHAuthorizationStatusNotDetermined:{   //未授权 发起授权
            block(YES);
        }
            break;
        case PHAuthorizationStatusRestricted:{  //拒绝
            block(NO);
        }
            break;
        case PHAuthorizationStatusDenied:{      //没有权限访问
            block(NO);
        }
            break;
        case PHAuthorizationStatusAuthorized:{  // 已经开启授权，可继续
            block(YES);
        }
            break;
        default:
            break;
    }
}

#pragma mark - ***** 日历、提醒事项授权 ******
+ (void)eventWitType:(EKEntityType)type Authorization:(AuthorizationBlock)block{
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:   //未选择
            block(YES);
            break;
        case EKAuthorizationStatusRestricted:      //无权限
            block(NO);
            break;
        case EKAuthorizationStatusDenied:          //拒绝
            block(NO);
            break;
        case EKAuthorizationStatusAuthorized:      //允许
            block(YES);
            break;
        default:
            break;
    }
}


#pragma mark - ***** 蓝牙授权 ******
+ (void)bluetoothPeripheralAuthorization:(AuthorizationBlock)block{
    CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    switch (authStatus) {
        case CBPeripheralManagerAuthorizationStatusNotDetermined:   //未选择
            break;
        case CBPeripheralManagerAuthorizationStatusRestricted:      //无权限
            block(NO);
            break;
        case CBPeripheralManagerAuthorizationStatusDenied:          //拒绝
            block(NO);
            break;
        case CBPeripheralManagerAuthorizationStatusAuthorized:      //允许
            block(YES);
            break;
        default:
            break;
    }
}

#pragma mark - ***** 麦克风 ******
+ (void)recordAuthorization:(AuthorizationBlock)block{
    AVAudioSessionRecordPermission authStatus = [[AVAudioSession sharedInstance] recordPermission];
    switch (authStatus) {
        case AVAudioSessionRecordPermissionUndetermined:   //未选择
            break;
        case AVAudioSessionRecordPermissionDenied:          //拒绝
            block(NO);
            break;
        case AVAudioSessionRecordPermissionGranted:         //允许
            block(YES);
            break;
        default:
            break;
    }
};

#pragma mark - ***** 通讯录授权 ******
+ (void)addressBookAuthorization:(AuthorizationBlock)block{
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authStatus) {
        case CNAuthorizationStatusNotDetermined:   //未选择
            break;
        case CNAuthorizationStatusRestricted:      //无权限
            block(NO);
            break;
        case CNAuthorizationStatusDenied:          //拒绝
            block(NO);
            break;
        case CNAuthorizationStatusAuthorized:      //允许
            block(YES);
            break;
        default:
            break;
    }
}



@end
