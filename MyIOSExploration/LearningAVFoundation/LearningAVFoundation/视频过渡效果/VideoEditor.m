//
//  VideoEditor.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/9.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "VideoEditor.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoEditor ()
@property (nonatomic, readwrite, retain) AVComposition *composition;
@property (nonatomic, readwrite, retain) AVVideoComposition *videoComposition;
@property (nonatomic, readwrite, retain) AVAudioMix *audioMix;
@property (nonatomic, readwrite, retain) AVPlayerItem *playerItem;
@property (nonatomic, readwrite, retain) AVSynchronizedLayer *synchronizedLayer;
@end

@implementation VideoEditor

- (void)buildCompositionObjectsForPlayback:(BOOL)forPlayback
{
    CGSize videoSize = [[_clips objectAtIndex:0] naturalSize];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = nil;
    AVMutableAudioMix *audioMix = nil;
    CALayer *animatedTitleLayer = nil;
    
    composition.naturalSize = videoSize;
    
    NSLog(@"videoSize = %@", NSStringFromCGSize(videoSize));
    
    if (self.transitionType == SimpleEditorTransitionTypeNone) {
        // No transitions: place clips into one video track and one audio track in composition.
        
        [self buildSequenceComposition:composition];
    }
    else {
        // With transitions:
        // Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
        // Set up the video composition to cycle between "pass through A", "transition from A to B",
        // "pass through B", "transition from B to A".
        
        videoComposition = [AVMutableVideoComposition videoComposition];
        [self buildTransitionComposition:composition andVideoComposition:videoComposition];
    }
    
    // If one is provided, add a commentary track and duck all other audio during it.
    if (self.commentary) {
        // Add the commentary track and duck all other audio during it.
        
        audioMix = [AVMutableAudioMix audioMix];
        [self addCommentaryTrackToComposition:composition withAudioMix:audioMix];
    }
    
    // Set up Core Animation layers to contribute a title animation overlay if we have a title set.
//    if (self.titleText) {
//        animatedTitleLayer = [self buildAnimatedTitleLayerForSize:videoSize];
//        
//        if (! forPlayback) {
//            // For export: build a Core Animation tree that contains both the animated title and the video.
//            CALayer *parentLayer = [CALayer layer];
//            CALayer *videoLayer = [CALayer layer];
//            parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
//            videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
//            [parentLayer addSublayer:videoLayer];
//            [parentLayer addSublayer:animatedTitleLayer];
//            
//            if (! videoComposition) {
//                // No transition set -- make a "pass through video track" video composition so we can include the Core Animation tree as a post-processing stage.
//                videoComposition = [AVMutableVideoComposition videoComposition];
//                
//                [self buildPassThroughVideoComposition:videoComposition forComposition:composition];
//            }
//            
//            videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
//        }
//    }
    
    if (videoComposition) {
        // Every videoComposition needs these properties to be set:
        videoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
        videoComposition.renderSize = videoSize;
    }
    
    self.composition = composition;
    self.videoComposition = videoComposition;
    self.audioMix = audioMix;
    
    self.synchronizedLayer = nil;

    if (forPlayback) {
#if TARGET_OS_EMBEDDED
        // Render high-def movies at half scale for real-time playback (device-only).
        if (videoSize.width > 640)
            videoComposition.renderScale = 0.5;
#endif // TARGET_OS_EMBEDDED
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:composition];
        playerItem.videoComposition = videoComposition;
        playerItem.audioMix = audioMix;
        self.playerItem = playerItem;
        
        if (animatedTitleLayer) {
            // Build an AVSynchronizedLayer that contains the animated title.
            self.synchronizedLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:self.playerItem];
            self.synchronizedLayer.bounds = CGRectMake(0, 0, videoSize.width, videoSize.height);
            [self.synchronizedLayer addSublayer:animatedTitleLayer];
        }
    }
}

- (void)buildSequenceComposition:(AVMutableComposition *)composition
{
    CMTime nextClipStartTime = kCMTimeZero;
    NSInteger i;
    
    // No transitions: place clips into one video track and one audio track in composition.
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    for (i = 0; i < [_clips count]; i++ ) {
        AVURLAsset *asset = [_clips objectAtIndex:i];
        NSValue *clipTimeRange = [_clipTimeRanges objectAtIndex:i];
        CMTimeRange timeRangeInAsset;
        if (clipTimeRange)
            timeRangeInAsset = [clipTimeRange CMTimeRangeValue];
        else
            timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        
        AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        [compositionVideoTrack insertTimeRange:timeRangeInAsset ofTrack:clipVideoTrack atTime:nextClipStartTime error:nil];
        
        //视频文件可能没有音频轨道，也就是静音的
        if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
            AVAssetTrack *clipAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            [compositionAudioTrack insertTimeRange:timeRangeInAsset ofTrack:clipAudioTrack atTime:nextClipStartTime error:nil];
        }
        
        // Note: This is largely equivalent:
        // [composition insertTimeRange:timeRangeInAsset ofAsset:asset atTime:nextClipStartTime error:NULL];
        // except that if the video tracks dimensions do not match, additional video tracks will be added to the composition.
        
        nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration);
    }
}


- (void)buildTransitionComposition:(AVMutableComposition *)composition andVideoComposition:(AVMutableVideoComposition *)videoComposition
{
    CMTime nextClipStartTime = kCMTimeZero;
    NSInteger i;
    
    // Make transitionDuration no greater than half the shortest clip duration.
    CMTime transitionDuration = self.transitionDuration;
    for (i = 0; i < [_clips count]; i++ ) {
        NSValue *clipTimeRange = [_clipTimeRanges objectAtIndex:i];
        if (clipTimeRange) {
            CMTime halfClipDuration = [clipTimeRange CMTimeRangeValue].duration;
            halfClipDuration.timescale *= 2; // You can halve a rational by doubling its denominator.
            transitionDuration = CMTimeMinimum(transitionDuration, halfClipDuration);
        }
    }
    
    // Add two video tracks and two audio tracks.
    AVMutableCompositionTrack *compositionVideoTracks[2];
    AVMutableCompositionTrack *compositionAudioTracks[2];
    compositionVideoTracks[0] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    compositionVideoTracks[1] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    compositionAudioTracks[0] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    compositionAudioTracks[1] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTimeRange *passThroughTimeRanges = alloca(sizeof(CMTimeRange) * [_clips count]);
    CMTimeRange *transitionTimeRanges = alloca(sizeof(CMTimeRange) * [_clips count]);
    
    // Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
    for (i = 0; i < [_clips count]; i++ ) {
        NSInteger alternatingIndex = i % 2; // alternating targets: 0, 1, 0, 1, ...
        AVURLAsset *asset = [_clips objectAtIndex:i];
        NSValue *clipTimeRange = [_clipTimeRanges objectAtIndex:i];
        CMTimeRange timeRangeInAsset;
        if (clipTimeRange)
            timeRangeInAsset = [clipTimeRange CMTimeRangeValue];
        else
            timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        
        AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        [compositionVideoTracks[alternatingIndex] insertTimeRange:timeRangeInAsset ofTrack:clipVideoTrack atTime:nextClipStartTime error:nil];
        
        //视频文件可能没有音频轨道，也就是静音的
        if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
            AVAssetTrack *clipAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            [compositionAudioTracks[alternatingIndex] insertTimeRange:timeRangeInAsset ofTrack:clipAudioTrack atTime:nextClipStartTime error:nil];
        }
        
        // Remember the time range in which this clip should pass through.
        // Every clip after the first begins with a transition.
        // Every clip before the last ends with a transition.
        // Exclude those transitions from the pass through time ranges.
        passThroughTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, timeRangeInAsset.duration);
        if (i > 0) {
            passThroughTimeRanges[i].start = CMTimeAdd(passThroughTimeRanges[i].start, transitionDuration);
            passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
        }
        if (i+1 < [_clips count]) {
            passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
        }
        
        // The end of this clip will overlap the start of the next by transitionDuration.
        // (Note: this arithmetic falls apart if timeRangeInAsset.duration < 2 * transitionDuration.)
        nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration);
        nextClipStartTime = CMTimeSubtract(nextClipStartTime, transitionDuration);
        
        // Remember the time range for the transition to the next item.
        transitionTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, transitionDuration);
    }
    
    // Set up the video composition if we are to perform crossfade or push transitions between clips.
    NSMutableArray *instructions = [NSMutableArray array];
    
    // Cycle between "pass through A", "transition from A to B", "pass through B", "transition from B to A".
    for (i = 0; i < [_clips count]; i++ ) {
        NSInteger alternatingIndex = i % 2; // alternating targets
        
        // Pass through clip i.
        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = passThroughTimeRanges[i];
        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[alternatingIndex]];
        
        passThroughInstruction.layerInstructions = [NSArray arrayWithObject:passThroughLayer];
        [instructions addObject:passThroughInstruction];
        
        if (i+1 < [_clips count]) {
            // Add transition from clip i to clip i+1.
            
            AVMutableVideoCompositionInstruction *transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            transitionInstruction.timeRange = transitionTimeRanges[i];
            AVMutableVideoCompositionLayerInstruction *fromLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[alternatingIndex]];
            AVMutableVideoCompositionLayerInstruction *toLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[1-alternatingIndex]];
            
            if (self.transitionType[i] == SimpleEditorTransitionTypeCrossFade) {
                // Fade out the fromLayer by setting a ramp from 1.0 to 0.0.
                [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRanges[i]];
                //				[fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-composition.naturalSize.width, 0.0) timeRange:transitionTimeRanges[i]];
            }
            else if (self.transitionType[i] == SimpleEditorTransitionTypePush) {
                // Set a transform ramp on fromLayer from identity to all the way left of the screen.
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-composition.naturalSize.width, 0.0) timeRange:transitionTimeRanges[i]];
                // Set a transform ramp on toLayer from all the way right of the screen to identity.
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(+composition.naturalSize.width, 0.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRanges[i]];
            }
            else if (self.transitionType[i] == SimpleEditorTransitionTypeCustom) {
                // Set a transform ramp on toLayer from all the way right of the screen to identity.
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-composition.naturalSize.width, 0.0) timeRange:transitionTimeRanges[i]];
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(+composition.naturalSize.width, 0.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRanges[i]];
                
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeScale(2, 2) timeRange:transitionTimeRanges[i]];
                
            }
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:fromLayer, toLayer, nil];
            [instructions addObject:transitionInstruction];
        }
    }
    
    videoComposition.instructions = instructions;
}

- (void)addCommentaryTrackToComposition:(AVMutableComposition *)composition withAudioMix:(AVMutableAudioMix *)audioMix
{
    NSInteger i;
    NSArray *tracksToDuck = [composition tracksWithMediaType:AVMediaTypeAudio]; // before we add the commentary
    
    // Clip commentary duration to composition duration.
    CMTimeRange commentaryTimeRange = CMTimeRangeMake(self.commentaryStartTime, self.commentary.duration);
    if (CMTIME_COMPARE_INLINE(CMTimeRangeGetEnd(commentaryTimeRange), >, [composition duration]))
        commentaryTimeRange.duration = CMTimeSubtract([composition duration], commentaryTimeRange.start);
    
    // Add the commentary track.
    AVMutableCompositionTrack *compositionCommentaryTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, commentaryTimeRange.duration) ofTrack:[[self.commentary tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:commentaryTimeRange.start error:nil];
    
    
    NSMutableArray *trackMixArray = [NSMutableArray array];
    CMTime rampDuration = CMTimeMake(1, 2); // half-second ramps
    for (i = 0; i < [tracksToDuck count]; i++) {
        AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:[tracksToDuck objectAtIndex:i]];
        [trackMix setVolumeRampFromStartVolume:1.0 toEndVolume:0.2 timeRange:CMTimeRangeMake(CMTimeSubtract(commentaryTimeRange.start, rampDuration), rampDuration)];
        [trackMix setVolumeRampFromStartVolume:0.2 toEndVolume:1.0 timeRange:CMTimeRangeMake(CMTimeRangeGetEnd(commentaryTimeRange), rampDuration)];
        [trackMixArray addObject:trackMix];
    }
    audioMix.inputParameters = trackMixArray;
}

- (void)buildPassThroughVideoComposition:(AVMutableVideoComposition *)videoComposition forComposition:(AVMutableComposition *)composition
{
    // Make a "pass through video track" video composition.
    AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [composition duration]);
    
    AVAssetTrack *videoTrack = [[composition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    passThroughInstruction.layerInstructions = [NSArray arrayWithObject:passThroughLayer];
    videoComposition.instructions = [NSArray arrayWithObject:passThroughInstruction];
}


- (CALayer *)buildAnimatedTitleLayerForSize:(CGSize)videoSize
{
    // Create a layer for the overall title animation.
    CALayer *animatedTitleLayer = [CALayer layer];
    
    // Create a layer for the text of the title.
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.string = self.titleText;
    titleLayer.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:12]);
    titleLayer.fontSize = videoSize.height / 6;
    //?? titleLayer.shadowOpacity = 0.5;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.bounds = CGRectMake(0, 0, videoSize.width, videoSize.height / 6);
    
    // Add it to the overall layer.
    [animatedTitleLayer addSublayer:titleLayer];
    
    // Create a layer that contains a ring of stars.
    CALayer *ringOfStarsLayer = [CALayer layer];
    
    CGImageRef picture1 = [UIImage imageNamed:@"1.JPG"].CGImage;
    CALayer *pictureLayer = [CALayer layer];
    pictureLayer.bounds = CGRectMake(0, 0, 100 , 100);
    pictureLayer.position = CGPointMake(0, 0);
    pictureLayer.contents = (__bridge id)picture1;
    [ringOfStarsLayer addSublayer:pictureLayer];
    CGImageRelease(picture1);
    
    // Rotate the ring of stars.
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    rotationAnimation.duration = 1.0f;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:videoSize.width];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0];
    rotationAnimation.additive = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.beginTime = 2.0f;
    //	rotationAnimation.cumulative = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [ringOfStarsLayer addAnimation:rotationAnimation forKey:nil];
    
    // Add the ring of stars to the overall layer.
    animatedTitleLayer.position = CGPointMake(videoSize.width / 2.0, videoSize.height / 2.0);
    [animatedTitleLayer addSublayer:ringOfStarsLayer];
    
    // Animate the opacity of the overall layer so that it fades out from 3 sec to 4 sec.
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.repeatCount = 1e100; // forever
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.additive = YES;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.beginTime = 1e-100;
    fadeAnimation.duration = 1.0;
    fadeAnimation.fillMode = kCAFillModeBoth;
    [animatedTitleLayer addAnimation:fadeAnimation forKey:nil];
    
    return animatedTitleLayer;
}

//- (void)beginExport{
//    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:AVAssetExportPresetHighestQuality];
//    session.videoComposition = self.videoComposition;
//    session.audioMix = self.audioMix;
//    session.outputURL = [self exportURL];
//    session.outputFileType = AVFileTypeMPEG4;
//    [session exportAsynchronouslyWithCompletionHandler:^{
//         dispatch_async(dispatch_get_main_queue(), ^{
//             [self exportDidFinish:session];
//         });
//     }];
//}
//
//- (void)exportDidFinish:(AVAssetExportSession*)session
//{
//    NSURL *outputURL = session.outputURL;
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    NSLog(@"outputURL = %@", outputURL);
//    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
//        [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error) {
//            if (error) {
//                NSString *message = @"Unable to write to Photos library.";
//                [AlertViewHelper alertWithTitle:message message:@"Write Failed" buttonTitles:@[@"知道了"] block:^(NSInteger buttonIndex) {
//                    
//                }];
//            }
//            [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
//        }];
//    } else {
//        NSLog(@"Video could not be exported to assets library.");
//    }
//}
//
//- (NSURL *)exportURL {
//    NSString *filePath = nil;
//    NSUInteger count = 0;
//    do {
//        filePath = NSTemporaryDirectory();
//        NSString *numberString = count > 0 ? [NSString stringWithFormat:@"%li", (unsigned long) count] : @"";
//        NSString *fileNameString = [NSString stringWithFormat:@"Masterpiece%@.mp4", numberString];
//        filePath = [filePath stringByAppendingPathComponent:fileNameString];
//        count++;
//    } while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
//    return [NSURL fileURLWithPath:filePath];
//}

- (AVAssetExportSession*)assetExportSessionWithPreset:(NSString*)presetName
{
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:presetName];
    session.videoComposition = self.videoComposition;
    session.audioMix = self.audioMix;
    return session;
}


@end









