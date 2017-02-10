//
//  LBETimeline.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBETimeline.h"
#import "LBEAudioItem.h"

@implementation LBETimeline

- (BOOL)isSimpleTimeline {
    for (LBEAudioItem *item in self.musicItems) {
        if (item.volumeAutomation.count > 0) {
            return NO;
        }
    }
    if (self.transitions.count > 0 || self.titles.count > 0) {
        return NO;
    }
    return YES;
}


@end
