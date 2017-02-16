//
//  SimpleEditor.m
//  LearnAVFoundation
//
//  Created by 林伟池 on 16/6/28.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "SimpleEditor.h"
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface SimpleEditor ()

@property (nonatomic, readwrite, retain) AVMutableComposition *composition;
@property (nonatomic, readwrite, retain) AVMutableVideoComposition *videoComposition;
@property (nonatomic, readwrite, retain) AVMutableAudioMix *audioMix;
@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, strong) NSTimer *timerEffect;

@end

@implementation SimpleEditor

- (void)buildTransitionComposition:(AVMutableComposition *)composition andVideoComposition:(AVMutableVideoComposition *)videoComposition andAudioMix:(AVMutableAudioMix *)audioMix
{
    CMTime nextClipStartTime = kCMTimeZero;
    NSInteger i;
    NSUInteger clipsCount = [self.clips count];
    
    // 确保最后合并后的视频，变换长度不会超过最小长度的一半
    CMTime transitionDuration = self.transitionDuration;
    for (i = 0; i < clipsCount; i++ ) {
        NSValue *clipTimeRange = [self.clipTimeRanges objectAtIndex:i];
        if (clipTimeRange) {
            CMTime halfClipDuration = [clipTimeRange CMTimeRangeValue].duration;
            halfClipDuration.timescale *= 2;
            transitionDuration = CMTimeMinimum(transitionDuration, halfClipDuration);
        }
    }
    
    // Add two video tracks and two audio tracks.
    AVMutableCompositionTrack *compositionVideoTracks[2];
//    AVMutableCompositionTrack *compositionAudioTracks[2];
    compositionVideoTracks[0] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]; // 添加视频轨道0
    compositionVideoTracks[1] = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]; // 添加视频轨道1
//    compositionAudioTracks[0] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]; // 添加音频轨道0
//    compositionAudioTracks[1] = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]; // 添加音频轨道1
    
    CMTimeRange *passThroughTimeRanges = alloca(sizeof(CMTimeRange) * clipsCount);
    CMTimeRange *transitionTimeRanges = alloca(sizeof(CMTimeRange) * clipsCount);
    
    // Place clips into alternating video & audio tracks in composition, overlapped by transitionDuration.
    for (i = 0; i < clipsCount; i++ ) {
        NSInteger alternatingIndex = i % 2; // alternating targets: 0, 1, 0, 1, ...
        AVURLAsset *asset = [self.clips objectAtIndex:i];
        NSValue *clipTimeRange = [self.clipTimeRanges objectAtIndex:i];
        CMTimeRange timeRangeInAsset;
        if (clipTimeRange) {
            timeRangeInAsset = [clipTimeRange CMTimeRangeValue];
        }
        else {
            timeRangeInAsset = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        }
        
        AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        NSError* error;
        [compositionVideoTracks[alternatingIndex] insertTimeRange:timeRangeInAsset ofTrack:clipVideoTrack atTime:nextClipStartTime error:&error];
        
        
//        AVAssetTrack *clipAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
//        [compositionAudioTracks[alternatingIndex] insertTimeRange:timeRangeInAsset ofTrack:clipAudioTrack atTime:nextClipStartTime error:&error];
//        
//        NSLog(@"add at %lf long %lf", CMTimeGetSeconds(timeRangeInAsset.start) + CMTimeGetSeconds(nextClipStartTime), CMTimeGetSeconds(timeRangeInAsset.duration));
        
        // 计算应该直接播放的区间
        // 从播放区间里面去掉变换区间
        passThroughTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, timeRangeInAsset.duration);
        if (i > 0) {
            passThroughTimeRanges[i].start = CMTimeAdd(passThroughTimeRanges[i].start, transitionDuration);
            passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
        }
        if (i+1 < clipsCount) {
            passThroughTimeRanges[i].duration = CMTimeSubtract(passThroughTimeRanges[i].duration, transitionDuration);
        }
//        NSLog(@"passthrough at %lf long %lf", CMTimeGetSeconds(passThroughTimeRanges[i].start), CMTimeGetSeconds(passThroughTimeRanges[i].duration));
        // 计算下一个插入点
        nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRangeInAsset.duration); // 加上持续时间
        nextClipStartTime = CMTimeSubtract(nextClipStartTime, transitionDuration); // 减去变换时间，得到下一个插入点
        
        // 第i个视频的变换时间为下一个的插入点，长度为变换时间
        if (i+1 < clipsCount) {
            transitionTimeRanges[i] = CMTimeRangeMake(nextClipStartTime, transitionDuration);
        }
//        NSLog(@"transitionTimeRanges at %lf long %lf", CMTimeGetSeconds(transitionTimeRanges[i].start), CMTimeGetSeconds(transitionTimeRanges[i].duration));
    }
    
    
    NSMutableArray *instructions = [NSMutableArray array]; // 视频操作指令集合
    NSMutableArray<AVAudioMixInputParameters *> *trackMixArray = [NSMutableArray<AVAudioMixInputParameters *> array]; // 音频轨道参数集合
    CGFloat videoWidth =  composition.naturalSize.width;
    CGFloat videoHeight =  composition.naturalSize.width;
    
    for (i = 0; i < clipsCount; i++ ) {
        NSInteger alternatingIndex = i % 2; // 轨道索引
        
        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction]; // 新建指令
        passThroughInstruction.timeRange = passThroughTimeRanges[i]; // 直接播放
        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[alternatingIndex]]; // 视频轨道操作指令
        
        passThroughInstruction.layerInstructions = [NSArray arrayWithObject:passThroughLayer];
        [instructions addObject:passThroughInstruction]; // 添加到指令集合
        
        if (i+1 < clipsCount) { // 不是最后一个
            AVMutableVideoCompositionInstruction *transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction]; // 新建指令
            transitionInstruction.timeRange = transitionTimeRanges[i]; // 变换时间
            AVMutableVideoCompositionLayerInstruction *fromLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[alternatingIndex]]; // 视频轨道操作指令
            AVMutableVideoCompositionLayerInstruction *toLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTracks[1-alternatingIndex]]; // 新的轨道指令AVFileTypeAppleM4A
            
            
            // ----------------------------------- 动画效果 -------------------------------------------------
            
            //set  transition for 2 slide show

            if(self.transitionType[i] == VideoTransitionTypeDisolve)
            {
                [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRanges[i]];
                [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypePushFromTop)
            {
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                               toEndTransform:CGAffineTransformMakeTranslation(0,videoHeight)
                                                    timeRange:transitionTimeRanges[i]];
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0,-videoHeight)
                                             toEndTransform:CGAffineTransformIdentity
                                                  timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypePushFromBottom)
            {
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                               toEndTransform:CGAffineTransformMakeTranslation(0,-videoHeight)
                                                    timeRange:transitionTimeRanges[i]];
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0,videoHeight)
                                             toEndTransform:CGAffineTransformIdentity
                                                  timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypePushFromLeft)
            {
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                               toEndTransform:CGAffineTransformMakeTranslation(videoWidth,0)
                                                    timeRange:transitionTimeRanges[i]];
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth,0)
                                             toEndTransform:CGAffineTransformIdentity
                                                  timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypePushFromRight)
            {
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                               toEndTransform:CGAffineTransformMakeTranslation(-videoWidth,0)
                                                    timeRange:transitionTimeRanges[i]];
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth,0)
                                             toEndTransform:CGAffineTransformIdentity
                                                  timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypeFadeIn)
            {
                [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypeFadeOut)
            {
                [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionTimeRanges[i]];
            }
            else if(self.transitionType[i] == VideoTransitionTypeZoomIn)
            {
                [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity
                                               toEndTransform:CGAffineTransformMakeScale(0.1,0.1)
                                                    timeRange:transitionTimeRanges[i]];
                [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeScale(0.1,0.1)
                                             toEndTransform:CGAffineTransformIdentity
                                                  timeRange:transitionTimeRanges[i]];
                
            }else if (self.transitionType[i] == VideoTransitionTypeWipe){
            
                CGFloat videoWidth = videoComposition.renderSize.width;
                CGFloat videoHeight = videoComposition.renderSize.height;
                CGRect startRect = CGRectMake(0.0f, 0.0f, videoWidth, videoHeight);
                CGRect endRect = CGRectMake(0.0f, videoHeight, videoWidth, 0.0f);
                [fromLayer setCropRectangleRampFromStartCropRectangle:startRect
                                                   toEndCropRectangle:endRect
                                                            timeRange:transitionTimeRanges[i]];
            }
            
            
            // ------------------------------------------------------------------------------------
            
            
            
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            [instructions addObject:transitionInstruction];
            
//            AVMutableAudioMixInputParameters *trackMix1 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTracks[alternatingIndex]]; // 音轨0的参数
//            
//            [trackMix1 setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:transitionTimeRanges[i]]; // 音轨0，变换期间音量从1.0到0.0
//            
//            [trackMixArray addObject:trackMix1];
//            
//            AVMutableAudioMixInputParameters *trackMix2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTracks[1 - alternatingIndex]]; // 音轨1的参数
//            
//            [trackMix2 setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:transitionTimeRanges[i]]; // 变换期间音量从0.0到1.0
//            //            [trackMix2 setVolumeRampFromStartVolume:1.0 toEndVolume:1.0 timeRange:passThroughTimeRanges[i + 1]]; // 播放期间音量 一直为1.0
//            
//            [trackMixArray addObject:trackMix2];
        }
        
    }
    
    audioMix.inputParameters = trackMixArray;
    videoComposition.instructions = instructions;
}


- (void)buildCompositionObjectsForPlayback
{
    if (kArrayIsEmpty(self.clips)) {
        self.composition = nil;
        self.videoComposition = nil;
        return;
    }
    CGSize videoSize = [[self.clips objectAtIndex:0] naturalSize];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = nil;
    AVMutableAudioMix *audioMix = nil;
    
    composition.naturalSize = videoSize;
    
    videoComposition = [AVMutableVideoComposition videoComposition];
    audioMix = [AVMutableAudioMix audioMix];
    
    [self buildTransitionComposition:composition andVideoComposition:videoComposition andAudioMix:audioMix];
    
    if (videoComposition) {
        // 通用属性
        videoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
        videoComposition.renderSize = videoSize;
    }
    
    self.videoComposition = videoComposition;
    self.composition = composition;
    self.audioMix = audioMix;
}

- (void)addVoiceEffectsWithAudioPath:(NSString *)audioPathString{
    
    // 添加声效
    NSString* audioSourceStr = [[NSBundle mainBundle] pathForResource:audioPathString ofType:@"mp3"];
    NSURL *bgMusicURL = [NSURL fileURLWithPath:audioSourceStr];
    AVURLAsset *assetMusic = [[AVURLAsset alloc] initWithURL:bgMusicURL options:nil];
    [self addAudioMixToComposition:self.composition withAudioMix:self.audioMix withAsset:assetMusic];
    
    
    [self applyVideoEffectsWithImage:kImage(@"image1.jpg") frame:CGRectMake(100, 50, 50, 50)];
}

- (void)addAudioMixToComposition:(AVMutableComposition *)composition withAudioMix:(AVMutableAudioMix *)audioMix withAsset:(AVURLAsset*)commentary
{
    NSInteger i;
    NSArray *tracksToDuck = [composition tracksWithMediaType:AVMediaTypeAudio];
    
    // 1. Clip commentary duration to composition duration.
    CMTimeRange commentaryTimeRange = CMTimeRangeMake(kCMTimeZero, commentary.duration);
    if (CMTIME_COMPARE_INLINE(CMTimeRangeGetEnd(commentaryTimeRange), >, [composition duration]))
        commentaryTimeRange.duration = CMTimeSubtract([composition duration], commentaryTimeRange.start);
    
    // 2. Add the commentary track.
    AVMutableCompositionTrack *compositionCommentaryTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack * commentaryTrack = [[commentary tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, commentaryTimeRange.duration) ofTrack:commentaryTrack atTime:commentaryTimeRange.start error:nil];
    
    // 3. Fade in for bgMusic
    CMTime fadeTime = CMTimeMake(1, 1);
    CMTimeRange startRange = CMTimeRangeMake(kCMTimeZero, fadeTime);
    NSMutableArray *trackMixArray = [NSMutableArray array];
    AVMutableAudioMixInputParameters *trackMixComentray = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:commentaryTrack];
    [trackMixComentray setVolumeRampFromStartVolume:0.0f toEndVolume:0.5f timeRange:startRange];
    [trackMixArray addObject:trackMixComentray];
    
    // 4. Fade in & Fade out for original voices
    for (i = 0; i < [tracksToDuck count]; i++)
    {
        CMTimeRange timeRange = [[tracksToDuck objectAtIndex:i] timeRange];
        if (CMTIME_COMPARE_INLINE(CMTimeRangeGetEnd(timeRange), ==, kCMTimeInvalid))
        {
            break;
        }
        
        CMTime halfSecond = CMTimeMake(1, 2);
        CMTime startTime = CMTimeSubtract(timeRange.start, halfSecond);
        CMTime endRangeStartTime = CMTimeAdd(timeRange.start, timeRange.duration);
        CMTimeRange endRange = CMTimeRangeMake(endRangeStartTime, halfSecond);
        if (startTime.value < 0)
        {
            startTime.value = 0;
        }
        
        [trackMixComentray setVolumeRampFromStartVolume:0.5f toEndVolume:0.2f timeRange:CMTimeRangeMake(startTime, halfSecond)];
        [trackMixComentray setVolumeRampFromStartVolume:0.2f toEndVolume:0.5f timeRange:endRange];
        [trackMixArray addObject:trackMixComentray];
    }
    
    audioMix.inputParameters = trackMixArray;
}

- (void)applyVideoEffectsWithImage:(UIImage*)image frame:(CGRect)frame
{
    CGSize effectSize = self.videoComposition.renderSize;
    AVMutableComposition *composition = self.composition;
    CGFloat startTime = 0;
    CGFloat duration = composition.duration.value/composition.duration.timescale;
    
    //创建水印背景layer
    CAShapeLayer *parentLayer=[CAShapeLayer layer];
    parentLayer.geometryFlipped=YES;
    parentLayer.frame = CGRectMake(0,0,effectSize.width,effectSize.height);
    
    CALayer *videoLayer=[CALayer layer];
    videoLayer.frame=CGRectMake(0,0,effectSize.width,effectSize.height);
    [parentLayer addSublayer:videoLayer];
    
    //创建水印
    CALayer *watermarkLayer=[CALayer layer];
    watermarkLayer.contentsGravity=@"resizeAspect";
    watermarkLayer.frame = frame;
    watermarkLayer.contents=(__bridge id _Nullable)image.CGImage;
    [parentLayer addSublayer:watermarkLayer];
    
    //添加水印显示时间段
    CGFloat endTime= startTime + duration;
    CGFloat allTime = composition.duration.value/composition.duration.timescale;
    
    if (!(startTime <= 0 && endTime >= allTime)) {
        //水印仅在特定时间显示
        watermarkLayer.opacity=0;
        
        [self addAnimationToWatermarkLayer:watermarkLayer show:YES beginTime:startTime];
        [self addAnimationToWatermarkLayer:watermarkLayer show:NO beginTime:endTime];
    }
    
    self.videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}

//给水印添加显示隐藏效果
- (void)addAnimationToWatermarkLayer:(CALayer *)layer show:(BOOL)isShow beginTime:(CGFloat)beginTime{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:0];
    [animation setFromValue:[NSNumber numberWithFloat:(isShow)?0.0:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:(isShow)?1.0:0.0]];
    [animation setBeginTime:(beginTime==0)?0.25:beginTime];//(从0开始显示的话系统会不显示,出现bug,必须拖延一点时间才正常,可能是需要反应时间吧)
    animation.autoreverses=NO;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [layer addAnimation:animation forKey:nil];
}

- (AVPlayerItem *)playerItem
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.composition];
    playerItem.videoComposition = self.videoComposition;
    playerItem.audioMix = self.audioMix;
    return playerItem;
}

- (void)exportSaveToLibrary:(BOOL)isSave exportSuccessed:(ExportSuccessBlock)block{
    
    if (self.composition == nil || [self.composition isKindOfClass:[NSNull class]]) {
        NSLog (@"视频压缩导出:传入的AVAsset为nil");
        return;
    }
    
    Run_Main(^{
        self.timerEffect = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(retrievingProgress) userInfo:nil
                                                       repeats:YES];
    });
    
    //创建导出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *outputURL = paths[0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    
    outputURL = [outputURL stringByAppendingPathComponent:@"CDPVideoEditorOutput.mp4"];
    //移除文件
    [manager removeItemAtPath:outputURL error:nil];
    NSLog(@"outputURL = %@", outputURL);
    
    //根据asset对象创建exportSession视频导出对象
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:AVAssetExportPresetMediumQuality];
    //音频混合器
    exportSession.audioMix = self.audioMix;
    //视频组合器
    exportSession.videoComposition = self.videoComposition;
    //视频导出路径
    exportSession.outputURL=[NSURL fileURLWithPath:outputURL];
    //导出格式
    exportSession.outputFileType=AVFileTypeMPEG4;
    self.exportSession = exportSession;
    //开始异步导出
    [[UIApplication sharedApplication] delegate].window.userInteractionEnabled=NO;
    
    kWeakSelf(self)
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        kStrongSelf(self)
        [[UIApplication sharedApplication] delegate].window.userInteractionEnabled = YES;
        switch (exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
            {
                //导出成功
                if (isSave == YES) {
                    // 保存到相册
                    [self writeVideoToPhotoLibrary:[NSURL fileURLWithPath:outputURL]];
                }
                Run_Main(^{
                    [self.timerEffect invalidate];
                    self.timerEffect = nil;
                    kSafeRun_Block(block, outputURL, YES);
                });
            }
                break;
            case AVAssetExportSessionStatusFailed:
            {
                //导出失败
                Run_Main(^{
                    NSLog(@"视频压缩导出失败error:%@",exportSession.error);
                    kSafeRun_Block(block, nil, NO);
                    [self.timerEffect invalidate];
                    self.timerEffect = nil;
                });
            }
                break;
            case AVAssetExportSessionStatusCancelled:
            {
                //导出取消
                Run_Main(^{
                    NSLog(@"视频压缩导出失败error:%@",exportSession.error);
                    kSafeRun_Block(block, nil, NO);
                    [self.timerEffect invalidate];
                    self.timerEffect = nil;
                });
            }
                break;
            default:
                break;
        }
    }];
}
#pragma mark - 根据视频url地址将其保存到本地照片库
- (void)writeVideoToPhotoLibrary:(nonnull NSURL *)url{
    if (url==nil||[url isKindOfClass:[NSNull class]]) {
        NSLog(@"视频保存到本地照片库:传入的视频url为nil");
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success==YES) {
            
        } else{
            NSLog(@"视频保存到本地照片库失败error:%@",error);
        }
    }];
}

- (void)retrievingProgress{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(exportVideoProgress:)]) {
        [self.delegate exportVideoProgress:self.exportSession.progress];
    }
}


- (NSURL *)exportURL {
    return [NSURL fileURLWithPath:[self exportURLString]];
}

- (NSString *)exportURLString{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Masterpiece.mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return filePath;
}

@end
