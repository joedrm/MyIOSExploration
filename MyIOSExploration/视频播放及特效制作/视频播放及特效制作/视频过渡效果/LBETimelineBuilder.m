//
//  LBETimelineBuilder.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBETimelineBuilder.h"
#import "LBEVideoTransition.h"
#import "LBEVideoItem.h"
#import "LBETimelineItemViewModel.h"

@implementation LBETimelineBuilder

+ (LBETimeline *)buildTimelineWithMediaItems:(NSArray *)mediaItems transitionsEnabled:(BOOL)transitionsEnabled {
    LBETimeline *timeline = [[LBETimeline alloc] init];
    timeline.videos = [self buildVideoItems:mediaItems[LBEVideoTrack]];
    
    if (transitionsEnabled) {
        for (LBEVideoItem *item in timeline.videos) {
            // Expand the duration to accomodate the overlaps
            CMTime expandedDuration = CMTimeMake(4, 1);
            item.timeRange = CMTimeRangeMake(kCMTimeZero, expandedDuration);
        }
    }
    timeline.transitions = [self buildTransitions:mediaItems[LBEVideoTrack]];
    timeline.voiceOvers = [self buildMediaItems:mediaItems[LBECommentaryTrack]];
    timeline.musicItems = [self buildMediaItems:mediaItems[LBEMusicTrack]];
    timeline.titles = [self buildMediaItems:mediaItems[LBETitleTrack]];
    return timeline;
}

+ (NSArray *)buildMediaItems:(NSArray *)adaptedItems {
    NSMutableArray *items = [NSMutableArray array];
    for (LBETimelineItemViewModel *adapter in adaptedItems) {
        [adapter updateTimelineItem];
        [items addObject:adapter.timelineItem];
    }
    return items;
}

+ (NSArray *)buildTransitions:(NSArray *)viewModels {
    NSMutableArray *items = [NSMutableArray array];
    for (id item in viewModels) {
        if ([item isKindOfClass:[LBEVideoTransition class]]) {
            [items addObject:item];
        }
    }
    return items;
}

+ (NSArray *)buildVideoItems:(NSArray *)viewModels {
    NSMutableArray *items = [NSMutableArray array];
    for (LBETimelineItemViewModel *model in viewModels) {
        if ([model isKindOfClass:[LBETimelineItemViewModel class]] && [model.timelineItem isKindOfClass:[LBEMediaItem class]]) {
            [model updateTimelineItem];
            [items addObject:model.timelineItem];
        }
    }
    return items;
}

+ (NSArray *)buildVideoTrackModels:(NSArray *)viewModels {
    NSMutableArray *items = [NSMutableArray array];
    for (id item in viewModels) {
        if ([item isKindOfClass:[LBETimelineItemViewModel class]] && [[item timelineItem] isKindOfClass:[LBEMediaItem class]]) {
            [item updateTimelineItem];
            [items addObject:[item timelineItem]];
        } else {
            [items addObject:item];
        }
    }
    return items;
}


@end
