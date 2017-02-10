//
//  LBETimelineItemViewModel.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBETimelineItemViewModel.h"
#import "LBEFunctions.h"

@implementation LBETimelineItemViewModel

+ (id)modelWithTimelineItem:(LBETimelineItem *)timelineItem {
    return [[self alloc] initWiLBETimelineItem:timelineItem];
}

- (id)initWiLBETimelineItem:(LBETimelineItem *)timelineItem {
    self = [super init];
    if (self) {
        _timelineItem = timelineItem;
        CMTimeRange maxTimeRange = CMTimeRangeMake(kCMTimeZero, timelineItem.timeRange.duration);
        _maxWidthInTimeline = LBEGetWidthForTimeRange(maxTimeRange, LBETimelineWidth / LBETimelineSeconds);
    }
    return self;
}

- (CGFloat)widthInTimeline {
    if (_widthInTimeline == 0.0f) {
        _widthInTimeline = LBEGetWidthForTimeRange(self.timelineItem.timeRange, LBETimelineWidth / LBETimelineSeconds);
    }
    return _widthInTimeline;
}

- (void)updateTimelineItem {
    
    if (self.positionInTimeline.x > 0.0f) {
        CMTime startTime = LBEGetTimeForOrigin(self.positionInTimeline.x, LBETimelineWidth / LBETimelineSeconds);
        self.timelineItem.startTimeInTimeline = startTime;
    }
    
//    self.timelineItem.timeRange = LBEGetTimeRangeForWidth(self.widthInTimeline, LBETimelineWidth / LBETimelineSeconds);
    self.timelineItem.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(4, 1));
}

@end
