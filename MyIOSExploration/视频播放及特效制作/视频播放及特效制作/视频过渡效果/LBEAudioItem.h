//
//  LBEAudioItem.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEMediaItem.h"

@interface LBEAudioItem : LBEMediaItem
@property (strong, nonatomic) NSArray *volumeAutomation;

+ (id)audioItemWithURL:(NSURL *)url;
@end
