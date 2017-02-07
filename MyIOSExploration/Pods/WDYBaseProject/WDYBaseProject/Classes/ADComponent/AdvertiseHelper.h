//
//  AdvertiseHelper.h
//  Pods
//
//  Created by fang wang on 17/1/9.
//
//  https://github.com/wujunyang/MobileProject/blob/master/MobileProject/Expand/Tool/AdvertiseHelper/AdvertiseHelper.h

#import <Foundation/Foundation.h>

@interface AdvertiseHelper : NSObject

+ (instancetype)sharedInstance;

+(void)showAdvertiserView:(NSArray *)imageArray;

@end
