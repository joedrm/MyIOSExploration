//
//  PlayerAnimationViewController.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PlayerAnimationViewController.h"

#define KVideoSavePath [kCachePath stringByAppendingPathComponent:@"final_video.mp4"]

static inline NSArray* ImageArr(){
    return @[kImage(@"image1.jpg"),
             kImage(@"image2.jpg"),
             kImage(@"image3.jpg"),
             kImage(@"image4.jpg"),
             kImage(@"image5.jpg")];
}

static float Druation = 20.0f;

static inline CGSize VideoSize(){
    return CGSizeMake(640, 480);
}

typedef void(^GenericCallback)(BOOL success, id result);

@interface PlayerAnimationViewController ()
@property (nonatomic, strong)AVPlayerItem *item;
@property (nonatomic, strong)AVQueuePlayer *player;
@property (nonatomic, strong) NSMutableArray *clips; // array of AVURLAssets
@property (nonatomic, strong) NSMutableArray *clipTimeRanges; // array of CMTimeRanges stored in NSValues.
@end

@implementation PlayerAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _clips = [[NSMutableArray alloc] initWithCapacity:ImageArr().count];
    _clipTimeRanges = [[NSMutableArray alloc] initWithCapacity:ImageArr().count];
    
    NSString* url = [[NSBundle mainBundle] pathForResource:@"final_video" ofType:@"mp4"];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (kStringIsEmpty(url)) {
        return;
    }
    NSURL *videoURL = [NSURL fileURLWithPath:url];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:[AVAsset assetWithURL:videoURL]];
    AVQueuePlayer *player = [AVQueuePlayer playerWithPlayerItem:item];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = player;
    vc.view.frame = CGRectMake(0, 200, kScreenWidth, 300);
    vc.view.backgroundColor = [UIColor blackColor];
    vc.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view addSubview:vc.view];
    
    [player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    self.item = item;
    self.player = player;
    
    
//    AVMutableComposition* compostion = [AVMutableComposition composition];
//    AVMutableCompositionTrack* trackA = [compostion addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    AVMutableCompositionTrack* trackB = [compostion addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    NSArray* videoTracks = @[trackA, trackB];
//    
//    NSArray* videoAssets = nil;
//    CMTime cursorTime = kCMTimeZero;
//    CMTime transitionDuration = CMTimeMake(2, 1);
//    for (NSUInteger i = 0; i < videoAssets.count; i ++) {
//        NSUInteger trackIndex = i % 2;
//        AVMutableCompositionTrack* currentTrack = videoTracks[trackIndex];
//        AVAsset* asset = videoAssets[i];
//        AVAssetTrack* assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
//        [currentTrack insertTimeRange:timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
//        cursorTime = CMTimeAdd(cursorTime, timeRange.duration);
//        cursorTime = CMTimeSubtract(cursorTime, transitionDuration);
//    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self imageSaveToVideo];
}

- (void)imageSaveToVideo{
    [self writeImages:ImageArr() ToMovieAtPath:KVideoSavePath withSize:VideoSize() inDuration:Druation byFPS:Druation/ImageArr().count];
    
}

#pragma mark - 将图片生成视频

- (void)writeImages:(NSArray *)imagesArray ToMovieAtPath:(NSString *)path withSize:(CGSize) size inDuration:(float)duration byFPS:(int32_t)fps {
    NSLog(@"videoFullPath = %@", path);
    if (kStringIsEmpty(path)) {
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    //Wire the writer:
    NSError *error =nil;
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:path]
                                                         fileType:AVFileTypeQuickTimeMovie
                                                            error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:
                                  AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    
    AVAssetWriterInput* videoWriterInput =[AVAssetWriterInput
                                           assetWriterInputWithMediaType:AVMediaTypeVideo
                                           outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor
                                                    assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                    sourcePixelBufferAttributes:nil];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    [videoWriter addInput:videoWriterInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //Write some samples:
    CVPixelBufferRef buffer =NULL;
    
    int frameCount = 0;
    
    NSUInteger imagesCount = [imagesArray count];
    float averageTime = duration / imagesCount;
    int averageFrame =(int)(averageTime * fps);
    
    for(UIImage *img in imagesArray)
    {
        buffer=[self pixelBufferFromCGImage:[img CGImage]size:size];
        BOOL append_ok =NO;
        int j = 0;
        while (!append_ok)
        {
            if(adaptor.assetWriterInput.readyForMoreMediaData)
            {
                CMTime frameTime = CMTimeMake(frameCount,(int32_t)fps);
                float frameSeconds = CMTimeGetSeconds(frameTime);
                NSLog(@"frameCount:%d,kRecordingFPS:%d,frameSeconds:%f",frameCount,fps,frameSeconds);
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTime];
                
                if(buffer)
                    [NSThread sleepForTimeInterval:0.05];
            }else{
                printf("adaptor not ready %d,%d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok){
            printf("error appendingimage %d times %d\n", frameCount, j);
        }
        frameCount = frameCount + averageFrame;
    }
    
    //Finish the session:
    [videoWriter finishWritingWithCompletionHandler:^{
        NSLog(@"finishWriting");
        
    }];
    
}



- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}

#pragma mark - 编辑视频，

- (void)editVideo2{
    
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    
}










- (void)editVideo{
    
    AVAsset* videoAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:KVideoSavePath]];
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    CGFloat durationStep = CMTimeGetSeconds(videoAsset.duration) / ImageArr().count;
    CGFloat regionStep = 1.0;
    __block CGRect cropRect = CGRectMake(0, 0, VideoSize().width, VideoSize().height);
    for (int i = 0; i < ImageArr().count; ++i)
    {
        regionStep = VideoSize().width / ImageArr().count;
        dispatch_async(serialQueue, ^{
            [self exportTrimmedVideo:videoAsset startTime:i*durationStep stopTime:i*durationStep+durationStep cropRegion:cropRect finishBlock:^(BOOL success, id result) {
                if (success)
                {
                    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:result]];
                    dispatch_group_t dispatchGroup = dispatch_group_create();
                    NSArray *assetKeysToLoad = @[@"tracks", @"duration", @"composable"];
                    [self loadAsset:asset withKeys:assetKeysToLoad usingDispatchGroup:dispatchGroup];
                    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
                        NSLog(@"finished");
                        if ([_clips count] == ImageArr().count)
                        {
                            
                        }
                    });
                } else {
                    NSLog(@"fail");
                }
            }];
        });
    }
}

- (void)exportTrimmedVideo:(AVAsset *)asset startTime:(CGFloat)startTime stopTime:(CGFloat)stopTime cropRegion:(CGRect)cropRect finishBlock:(GenericCallback)finishBlock
{
    if (!asset)
    {
        NSLog(@"asset is empty.");
        
        if (finishBlock)
        {
            finishBlock(NO, @"MsgConvertFailed");
        }
    }
    
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(stopTime - startTime, asset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [videoCompositionTrack insertTimeRange:range ofTrack:assetVideoTrack atTime:kCMTimeZero error:nil];
    [videoCompositionTrack setPreferredTransform:assetVideoTrack.preferredTransform];
    
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMakeWithSeconds(1.0 / assetVideoTrack.nominalFrameRate, assetVideoTrack.naturalTimeScale);
    videoComposition.renderSize =  cropRect.size; //CGSizeMake(assetVideoTrack.naturalSize.height, assetVideoTrack.naturalSize.height);
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction
                                                                   videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    NSString *exportPath = [self getTempOutputFilePath];
    unlink([exportPath UTF8String]);
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = exportUrl;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    if (videoComposition)
    {
        exportSession.videoComposition = videoComposition;
    }
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([exportSession status])
        {
            case AVAssetExportSessionStatusCompleted:
            {
                if (finishBlock)
                {
                    finishBlock(YES, exportPath);
                }
                
                NSLog(@"Export Successful.");
                
                break;
            }
            case AVAssetExportSessionStatusFailed:
            {
                if (finishBlock)
                {
                    finishBlock(NO, @"MsgConvertFailed");
                }
                
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
            }
            case AVAssetExportSessionStatusCancelled:
            {
                NSLog(@"Export canceled");
                break;
            }
            default:
            {
                NSLog(@"NONE");
                break;
            }
        }
    }];
}

- (void)loadAsset:(AVAsset *)asset withKeys:(NSArray *)assetKeysToLoad usingDispatchGroup:(dispatch_group_t)dispatchGroup
{
    dispatch_group_enter(dispatchGroup);
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoad completionHandler:^(){
        for (NSString *key in assetKeysToLoad)
        {
            NSError *error;
            if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
            {
                NSLog(@"Key value loading failed for key:%@ with error: %@", key, error);
                goto bail;
            }
        }
        
        if (![asset isComposable])
        {
            NSLog(@"Asset is not composable");
            goto bail;
        }
        
        [_clips addObject:asset];
        [_clipTimeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration])]];
        
    bail:
        {
            dispatch_group_leave(dispatchGroup);
        }
    }];
}



- (NSString*)getTempOutputFilePath
{
    NSString *path = kCachePath;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mov"];
    return fileName;
}

- (UIImageOrientation)getVideoOrientationFromAsset:(AVAsset *)asset
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIImageOrientationLeft; //return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIImageOrientationRight; //return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIImageOrientationDown; //return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIImageOrientationUp;  //return UIInterfaceOrientationPortrait;
}

- (void)playEnd{
    [self.item seekToTime:kCMTimeZero];
    [self.player pause];
}

- (void)applicationWillResignActive{
    [self.player pause];
}


@end
