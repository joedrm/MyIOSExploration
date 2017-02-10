//
//  LBEVolumeAutomation.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEVolumeAutomation.h"

@implementation LBEVolumeAutomation

+ (id)volumeAutomationWithTimeRange:(CMTimeRange)timeRange
                        startVolume:(CGFloat)startVolume
                          endVolume:(CGFloat)endVolume {
    
    LBEVolumeAutomation *automation = [[LBEVolumeAutomation alloc] init];
    automation.timeRange = timeRange;
    automation.startVolume = startVolume;
    automation.endVolume = endVolume;
    return automation;
}

@end
