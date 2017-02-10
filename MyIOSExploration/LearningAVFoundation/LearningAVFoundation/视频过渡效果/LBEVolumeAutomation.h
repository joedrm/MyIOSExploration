//
//  LBEVolumeAutomation.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBEVolumeAutomation : NSObject

+ (id)volumeAutomationWithTimeRange:(CMTimeRange)timeRange startVolume:(CGFloat)startVolume endVolume:(CGFloat)endVolume;
@property (nonatomic) CMTimeRange timeRange;
@property (nonatomic) CGFloat startVolume;
@property (nonatomic) CGFloat endVolume;

@end
