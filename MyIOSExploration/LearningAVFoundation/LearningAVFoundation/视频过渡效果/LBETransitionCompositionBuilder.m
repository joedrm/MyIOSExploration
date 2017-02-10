//
//  LBETransitionCompositionBuilder.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBETransitionCompositionBuilder.h"
#import "LBEMediaItem.h"
#import "LBEAudioItem.h"
#import "LBEVideoItem.h"
#import "LBETransitionComposition.h"
#import "LBEFunctions.h"
#import "LBETransitionInstructions.h"
#import "LBEVolumeAutomation.h"

@interface LBETransitionCompositionBuilder ()
@property (strong, nonatomic) LBETimeline *timeline;
@property (strong, nonatomic) AVMutableComposition *composition;
@property (weak, nonatomic) AVMutableCompositionTrack *musicTrack;
@end

@implementation LBETransitionCompositionBuilder

- (id)initWithTimeline:(LBETimeline *)timeline {
    self = [super init];
    if (self) {
        _timeline = timeline;
    }
    return self;
}

- (id <CompositionProtocol>)buildComposition {
    self.composition = [AVMutableComposition composition];
    [self buildCompositionTracks];
    AVVideoComposition *videoComposition = [self buildVideoComposition];
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
        NSLog(@"item.timeRange.start = %lld, item.timeRange.duration = %lld", item.timeRange.start.value, item.timeRange.duration.value);
        
        cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
        cursorTime = CMTimeSubtract(cursorTime, transitionDuration);
        
        NSLog(@"cursorTime = %lld", cursorTime.value);
    }
    
    [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:self.timeline.voiceOvers];
    NSArray *musicItems = self.timeline.musicItems;
    self.musicTrack = [self addCompositionTrackOfType:AVMediaTypeAudio withMediaItems:musicItems];
}

- (AVVideoComposition *)buildVideoComposition {
    
    AVVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:self.composition];
    NSArray *transitionInstructions = [self transitionInstructionsInVideoComposition:videoComposition];
    
    for (LBETransitionInstructions *instructions in transitionInstructions) {
        CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(3, 1), CMTimeMake(4, 1));//instructions.compositionInstruction.timeRange;
        AVMutableVideoCompositionLayerInstruction *fromLayer = instructions.fromLayerInstruction;
        AVMutableVideoCompositionLayerInstruction *toLayer = instructions.toLayerInstruction;
        
        LBEVideoTransitionType type = LBEVideoTransitionTypeDissolve;//instructions.transition.type;
    
        // 动画效果
        if (type == LBEVideoTransitionTypeDissolve) {
            NSLog(@"%.2lld, %.2lld", timeRange.duration.value, timeRange.start.value);
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:timeRange];
            [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:timeRange];
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

- (AVMutableCompositionTrack *)addCompositionTrackOfType:(NSString *)mediaType withMediaItems:(NSArray *)mediaItems {
    
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
        AVMutableAudioMixInputParameters *parameters =
        [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.musicTrack];
        for (LBEVolumeAutomation *automation in item.volumeAutomation) {
            [parameters setVolumeRampFromStartVolume:automation.startVolume toEndVolume:automation.endVolume timeRange:automation.timeRange];
        }
        audioMix.inputParameters = @[parameters];
        return audioMix;
    }
    return nil;
}


@end
