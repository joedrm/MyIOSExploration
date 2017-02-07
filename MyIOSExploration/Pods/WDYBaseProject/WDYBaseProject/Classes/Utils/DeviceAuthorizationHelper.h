//
//  CameraAuthorizeHelper.h
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//  相机、摄像头、定位、照片库、蓝牙、麦克风、通讯录等权限校验工具类
//  参考：https://github.com/mk2016/MKToolsKit

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef void (^AuthorizationBlock)(BOOL bRet);

@interface DeviceAuthorizationHelper : NSObject


/** 相机授权 */
+ (void)cameraAuthorization:(AuthorizationBlock)block;

/** 判断设备是否有摄像头 */
- (BOOL)isCameraAvailable;

/** 前面的摄像头是否可用 */
- (BOOL)isFrontCameraAvailable;

/** 后面的摄像头是否可用 */
- (BOOL)isRearCameraAvailable;

/** 定位授权 */
+ (void)locationAuthorization:(AuthorizationBlock)block;

/** 照片库授权 */
+ (void)assetsLibAuthorization:(AuthorizationBlock)block;

/** 日历、提醒事项授权 */
+ (void)eventWitType:(EKEntityType)type Authorization:(AuthorizationBlock)block;

/** 蓝牙授权 */
+ (void)bluetoothPeripheralAuthorization:(AuthorizationBlock)block;

/** 麦克风 */
+ (void)recordAuthorization:(AuthorizationBlock)block;

/** 通讯录授权 */
+ (void)addressBookAuthorization:(AuthorizationBlock)block;

@end
