//
//  LBEAudioMixCompositionBuilder.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEAudioMixCompositionBuilder.h"
#import "LBEAudioMixComposition.h"
#import "LBEAudioItem.h"
#import "LBEVolumeAutomation.h"
#import "LBEMediaItem.h"

@interface LBEAudioMixCompositionBuilder ()
@property (strong, nonatomic) LBETimeline *timeline;
@property (strong, nonatomic) AVMutableComposition *composition;
@end

@implementation LBEAudioMixCompositionBuilder

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
    AVMutableCompositionTrack *musicTrack = [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:self.timeline.musicItems];
    AVAudioMix *audioMix = [self buildAudioMixWithTrack:musicTrack];
    return [LBEAudioMixComposition compositionWithComposition:self.composition audioMix:audioMix];
}

- (AVAudioMix *)buildAudioMixWithTrack:(AVCompositionTrack *)track {
    LBEAudioItem *item = [self.timeline.musicItems firstObject];
    if (item) {
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        AVMutableAudioMixInputParameters *parameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        for (LBEVolumeAutomation *automation in item.volumeAutomation) {
            [parameters setVolumeRampFromStartVolume:automation.startVolume toEndVolume:automation.endVolume timeRange:automation.timeRange];
        }
        audioMix.inputParameters = @[parameters];
        return audioMix;
    }
    return nil;
}

- (AVMutableCompositionTrack *)addCompositionTrackOfType:(NSString *)type withMediaItems:(NSArray *)mediaItems {
    if (!kArrayIsEmpty(mediaItems)) {
        CMPersistentTrackID trackID = kCMPersistentTrackID_Invalid;
        AVMutableCompositionTrack *compositionTrack = [self.composition addMutableTrackWithMediaType:type preferredTrackID:trackID];
        CMTime cursorTime = kCMTimeZero;
        for (LBEMediaItem *item in mediaItems) {
            if (CMTIME_COMPARE_INLINE(item.startTimeInTimeline, !=, kCMTimeInvalid)) {
                cursorTime = item.startTimeInTimeline;
            }
            AVAssetTrack *assetTrack = [[item.asset tracksWithMediaType:type] firstObject];
            [compositionTrack insertTimeRange:item.timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
            cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
        }
        return compositionTrack;
    }
    return nil;
}


@end
