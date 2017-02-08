//
//  LBEBasicCompositionBuilder.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEBasicCompositionBuilder.h"
#import "LBEBasicComposition.h"
#import "LBEMediaItem.h"

@interface LBEBasicCompositionBuilder ()
@property (strong, nonatomic) LBETimeline *timeline;
@property (strong, nonatomic) AVMutableComposition *composition;
@end

@implementation LBEBasicCompositionBuilder

- (id)initWithTimeline:(LBETimeline *)timeline {
    self = [super init];
    if (self) {
        _timeline = timeline;
    }
    return self;
}

- (id <CompositionProtocol>)buildComposition {
    self.composition = [AVMutableComposition composition];
    [self addCompositionTrackOfType:AVMediaTypeVideo withMediaItems:self.timeline.videos];
    [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:self.timeline.voiceOvers];
    [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:self.timeline.musicItems];
    return [LBEBasicComposition compositionWithComposition:self.composition];
}

- (void)addCompositionTrackOfType:(NSString *)mediaType withMediaItems:(NSArray *)mediaItems
{
    if (!kArrayIsEmpty(mediaItems)) {
        CMPersistentTrackID trackID = kCMPersistentTrackID_Invalid;
        AVMutableCompositionTrack *compositionTrack =
        [self.composition addMutableTrackWithMediaType:mediaType preferredTrackID:trackID];
        CMTime cursorTime = kCMTimeZero;
        for (LBEMediaItem *item in mediaItems) {
            if (CMTIME_COMPARE_INLINE(item.startTimeInTimeline, !=, kCMTimeInvalid)) {
                cursorTime = item.startTimeInTimeline;
            }
            AVAssetTrack *assetTrack = [[item.asset tracksWithMediaType:mediaType] firstObject];
            [compositionTrack insertTimeRange:item.timeRange  ofTrack:assetTrack atTime:cursorTime error:nil];
            cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
        }
    }
}
@end



