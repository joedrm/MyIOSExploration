//
//  LBEManualTransitionCompositionBuilder.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEManualTransitionCompositionBuilder.h"
#import "LBEMediaItem.h"
#import "LBEAudioItem.h"
#import "LBEVideoItem.h"
#import "LBETransitionComposition.h"
#import "LBEFunctions.h"
#import "LBETransitionInstructions.h"
#import "LBEVolumeAutomation.h"

@interface LBEManualTransitionCompositionBuilder ()
@property (strong, nonatomic) LBETimeline *timeline;
@property (strong, nonatomic) AVMutableComposition *composition;
@property (strong, nonatomic) AVVideoComposition *videoComposition;
@property (weak, nonatomic) AVMutableCompositionTrack *musicTrack;
@property (strong, nonatomic) NSMutableArray *passThroughTimeRanges;
@property (strong, nonatomic) NSMutableArray *transitionTimeRanges;
@end

@implementation LBEManualTransitionCompositionBuilder

- (id)initWithTimeline:(LBETimeline *)timeline {
    self = [super init];
    if (self) {
        _timeline = timeline;
        _passThroughTimeRanges = [NSMutableArray array];
        _transitionTimeRanges = [NSMutableArray array];
    }
    return self;
}

- (id <CompositionProtocol>)buildComposition {
    
    self.composition = [AVMutableComposition composition];
    [self buildCompositionTracks];
    [self calculateTimeRanges];
    AVVideoComposition *videoComposition = [self buildVideoCompositionAndInstructions];
    AVAudioMix *audioMix = [self buildAudioMix];
    return [[LBETransitionComposition alloc] initWithComposition:self.composition videoComposition:videoComposition audioMix:audioMix];
}

- (void)buildCompositionTracks {
    CMPersistentTrackID trackID = kCMPersistentTrackID_Invalid;
    AVMutableCompositionTrack *compositionTrackA = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:trackID];
    AVMutableCompositionTrack *compositionTrackB = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:trackID];
    NSArray *videoTracks = @[compositionTrackA, compositionTrackB];
    CMTime cursorTime = kCMTimeZero;
    CMTime transitionDuration = kCMTimeZero;
    if (!kArrayIsEmpty(self.timeline.transitions)) {
        transitionDuration = LBEDefaultTransitionDuration;
    }
    NSArray *videos = self.timeline.videos;
    for (NSUInteger i = 0; i < videos.count; i++) {
        NSUInteger trackIndex = i % 2;
        LBEVideoItem *item = videos[i];
        AVMutableCompositionTrack *currentTrack = videoTracks[trackIndex];
        AVAssetTrack *assetTrack = [[item.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        [currentTrack insertTimeRange:item.timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
        cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
        cursorTime = CMTimeSubtract(cursorTime, transitionDuration);
    }
    
    [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:self.timeline.voiceOvers];
    self.musicTrack = [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:self.timeline.musicItems];
}

- (void)calculateTimeRanges {
    
    CMTime cursorTime = kCMTimeZero;
    CMTime transDuration = LBEDefaultTransitionDuration;
    transDuration.value = 1000000000;
    transDuration.timescale = 1000000000;
    NSUInteger videoCount = self.timeline.videos.count;
    for (NSUInteger i = 0; i < videoCount; i++) {
        LBEMediaItem *item = self.timeline.videos[i];
        CMTimeRange timeRange = CMTimeRangeMake(cursorTime, item.timeRange.duration);
        if (i > 0) {
            timeRange.start = CMTimeAdd(timeRange.start, transDuration);
            timeRange.duration = CMTimeSubtract(timeRange.duration, transDuration);
        }
        
        if (i + 1 < videoCount) {
            timeRange.duration = CMTimeSubtract(timeRange.duration, transDuration);
        }
        
        [self.passThroughTimeRanges addObject:[NSValue valueWithCMTimeRange:timeRange]];

        cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
        cursorTime = CMTimeSubtract(cursorTime, transDuration);
        
        if (i + 1 < videoCount) {
            timeRange = CMTimeRangeMake(cursorTime, transDuration);
            NSValue *timeRangeValue = [NSValue valueWithCMTimeRange:timeRange];
            [self.transitionTimeRanges addObject:timeRangeValue];
        }
    }
}

- (AVMutableVideoComposition *)buildVideoCompositionAndInstructions {
    
    NSMutableArray *compositionInstructions = [NSMutableArray array];
    NSArray *tracks = [self.composition tracksWithMediaType:AVMediaTypeVideo];
    for (NSUInteger i = 0; i < self.passThroughTimeRanges.count; i++) {
        NSUInteger trackIndex = i % 2;
        AVMutableCompositionTrack *currentTrack = tracks[trackIndex];
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = [self.passThroughTimeRanges[i] CMTimeRangeValue];
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:currentTrack];
        
        instruction.layerInstructions = @[layerInstruction];
        [compositionInstructions addObject:instruction];
        if (i < self.transitionTimeRanges.count) {
            AVCompositionTrack *foregroundTrack = tracks[trackIndex];
            AVCompositionTrack *backgroundTrack = tracks[1 - trackIndex];
            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            CMTimeRange timeRange = [self.transitionTimeRanges[i] CMTimeRangeValue];
            instruction.timeRange = timeRange;
            AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = [AVMutableVideoCompositionLayerInstruction
             videoCompositionLayerInstructionWithAssetTrack:foregroundTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerInstruction = [AVMutableVideoCompositionLayerInstruction
             videoCompositionLayerInstructionWithAssetTrack:backgroundTrack];
            instruction.layerInstructions = @[fromLayerInstruction, toLayerInstruction];
            [compositionInstructions addObject:instruction];
        }
    }
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = compositionInstructions;
    videoComposition.renderSize = CGSizeMake(1280.0f, 720.0f);
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.renderScale = 1.0f;
    return videoComposition;
}

- (AVVideoComposition *)buildVideoComposition {
    
    AVVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:self.composition];
    NSArray *transitionInstructions = [self transitionInstructionsInVideoComposition:videoComposition];
    
    for (LBETransitionInstructions *instructions in transitionInstructions) {
        
        CMTimeRange timeRange = instructions.compositionInstruction.timeRange;
        AVMutableVideoCompositionLayerInstruction *fromLayer = instructions.fromLayerInstruction;
        AVMutableVideoCompositionLayerInstruction *toLayer = instructions.toLayerInstruction;
        LBEVideoTransitionType type = instructions.transition.type;
        
        if (type == LBEVideoTransitionTypeDissolve) {
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:timeRange];
        }
        
        if (type == LBEVideoTransitionTypePush) {
            CGAffineTransform identityTransform = CGAffineTransformIdentity;
            CGFloat videoWidth = videoComposition.renderSize.width;
            CGAffineTransform fromDestTransform = CGAffineTransformMakeTranslation(-videoWidth, 0.0);
            CGAffineTransform toStartTransform = CGAffineTransformMakeTranslation(videoWidth, 0.0);
            [fromLayer setTransformRampFromStartTransform:identityTransform toEndTransform:fromDestTransform timeRange:timeRange];
            [toLayer setTransformRampFromStartTransform:toStartTransform toEndTransform:identityTransform timeRange:timeRange];
        }
        
        if (type == LBEVideoTransitionTypeWipe) {
            
            CGFloat videoWidth = videoComposition.renderSize.width;
            CGFloat videoHeight = videoComposition.renderSize.height;
            CGRect startRect = CGRectMake(0.0f, 0.0f, videoWidth, videoHeight);
            CGRect endRect = CGRectMake(0.0f, videoHeight, videoWidth, 0.0f);
            [fromLayer setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:timeRange];
        }
        instructions.compositionInstruction.layerInstructions = @[fromLayer, toLayer];
    }
    return videoComposition;
}


- (NSArray *)transitionInstructionsInVideoComposition:(AVVideoComposition *)vc {
    
    NSMutableArray *transitionInstructions = [NSMutableArray array];
    int layerInstructionIndex = 1;
    NSArray *compositionInstructions = vc.instructions;
    for (AVMutableVideoCompositionInstruction *vci in compositionInstructions) {
        if (vci.layerInstructions.count == 2) {
            LBETransitionInstructions *instructions = [[LBETransitionInstructions alloc] init];
            instructions.compositionInstruction = vci;
            instructions.fromLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[1 - layerInstructionIndex];
            instructions.toLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[layerInstructionIndex];
            [transitionInstructions addObject:instructions];
            layerInstructionIndex = layerInstructionIndex == 1 ? 0 : 1;
        }
    }
    
    NSArray *transitions = self.timeline.transitions;
    if (kArrayIsEmpty(transitions)) {
        return transitionInstructions;
    }
    NSAssert(transitionInstructions.count == transitions.count, @"Instruction count and transition count do not match.");
    
    for (NSUInteger i = 0; i < transitionInstructions.count; i++) {
        LBETransitionInstructions *tis = transitionInstructions[i];
        tis.transition = self.timeline.transitions[i];
    }
    return transitionInstructions;
}

- (AVMutableCompositionTrack *)addCompositionTrackOfType:(NSString *)mediaType
                                          withMediaItems:(NSArray *)mediaItems {
    
    AVMutableCompositionTrack *compositionTrack = nil;
    
    if (!kArrayIsEmpty(mediaItems)) {
        compositionTrack =
        [self.composition addMutableTrackWithMediaType:mediaType preferredTrackID:kCMPersistentTrackID_Invalid];
        CMTime cursorTime = kCMTimeZero;
        for (LBEMediaItem *item in mediaItems) {
            if (CMTIME_COMPARE_INLINE(item.startTimeInTimeline, !=, kCMTimeInvalid)) {
                cursorTime = item.startTimeInTimeline;
            }
            AVAssetTrack *assetTrack = [[item.asset tracksWithMediaType:mediaType] firstObject];
            [compositionTrack insertTimeRange:item.timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
            cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
        }
    }
    
    return compositionTrack;
}

- (AVAudioMix *)buildAudioMix {
    NSArray *items = self.timeline.musicItems;
    if (items.count == 1) {
        LBEAudioItem *item = self.timeline.musicItems[0];
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        AVMutableAudioMixInputParameters *parameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.musicTrack];
        for (LBEVolumeAutomation *automation in item.volumeAutomation) {
            [parameters setVolumeRampFromStartVolume:automation.startVolume toEndVolume:automation.endVolume timeRange:automation.timeRange];
        }
        audioMix.inputParameters = @[parameters];
        return audioMix;
    }
    return nil;
}
@end
