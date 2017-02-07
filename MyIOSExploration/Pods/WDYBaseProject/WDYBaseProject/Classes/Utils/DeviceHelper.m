//
//  DeviceHelper.m
//  Pods
//
//  Created by fang wang on 17/1/19.
//
//

#import "DeviceHelper.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>
//#import "SSKeychain.h"

//uudi
static NSString* const kMKToolkitUUIDString             = @"kMKToolkitUUID";

@implementation DeviceHelper

//+ (NSString *)getUUID{
//    NSString* retrieveuuid = [SSKeychain passwordForService:kMKToolkitUUIDString account:@"user"];
//    if ([retrieveuuid isEqualToString:@""] || retrieveuuid == NULL) {
//        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
//        assert(uuidRef != NULL);
//        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuidRef);
//        retrieveuuid = [NSString stringWithFormat:@"%@", uuidStr];
//        [SSKeychain setPassword:retrieveuuid forService:kMKToolkitUUIDString account:@"user"];
//        CFRelease(uuidRef);
//        CFRelease(uuidStr);
//    }
//    return retrieveuuid;
//}

#pragma mark - ***** app 版本号 ******

+ (NSString *)appBundleShortVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBundleVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (int)appIntVersion{
    NSString *nowShotV = [self appBundleVersion];
    NSArray *numArray = [nowShotV componentsSeparatedByString:@"."];
    int versionInt = 0;
    if (numArray.count > 0) {
        for (NSInteger i = 0; i < numArray.count; i++) {
            NSString *numStr = numArray[i];
            versionInt = versionInt*10 + numStr.intValue;
        }
    }
    return versionInt;
}

#pragma mark - ***** 系统信息 ******
+ (float)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)systemVersionString{
    return [[UIDevice currentDevice] systemVersion];
}

+ (BOOL)isSystemIos7Later{
    if ([self systemVersion] >= 7.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSystemIos8Later{
    if ([self systemVersion] >= 8.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSystemIos10Later{
    if ([self systemVersion] >= 10.0) {
        return YES;
    }
    return NO;
}

+ (NSString *)deviceType{
    NSString *platform = [self devicePlatform];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone4,2"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone4,3"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    //iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4(WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4(Cellular)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2(WiFi)";
    if ([platform isEqualToString:@"iPad5,5"])      return @"iPad Air 2(Cellular)";
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro(WiFi) 9.7-inch";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro(Cellular) 9.7-inch";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro(WiFi) 12.9-inch";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro(Cellular) 12.9-inch";
    
    //Simulator
    if ([platform isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    
    if ([platform hasPrefix:@"iPad"])               return @"iPad";
    if ([platform hasPrefix:@"iPod"])               return @"iPod";
    if ([platform hasPrefix:@"iPhone"])             return @"iPhone";
    return platform;
    
}

+ (NSString *)devicePlatform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
    
    //    struct utsname DT;
    //    // Get the system information
    //    uname(&DT);
    //    // Set the device type to the machine type
    //    NSString *deviceType = [NSString stringWithFormat:@"%s", DT.machine];
    //    return deviceType
}


#pragma mark - ***** 手机信息 ******
+ (NSString *)phoneName{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)phoneModel{
    return [[UIDevice currentDevice] model];
}

+ (float)screenBrightness {
    return [UIScreen mainScreen].brightness;
}

+ (float)batteryLevel {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    float BatteryLevel = -1;
    
    float BatteryCharge = [UIDevice currentDevice].batteryLevel;
    if (BatteryCharge >= 0.0f) {
        BatteryLevel = BatteryCharge * 100;
    }
    return BatteryLevel;
}

// Charging?
+ (BOOL)charging{
    UIDevice *Device = [UIDevice currentDevice];
    Device.batteryMonitoringEnabled = YES;
    
    // Check the battery state
    if ([Device batteryState] == UIDeviceBatteryStateCharging || [Device batteryState] == UIDeviceBatteryStateFull) {
        return true;
    } else {
        return false;
    }
}


@end
