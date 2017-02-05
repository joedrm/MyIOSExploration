//
//  PlayerAnimationViewController.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/4.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PlayerAnimationViewController.h"

@interface PlayerAnimationViewController ()
@property (nonatomic, strong)AVPlayerItem *item;
@property (nonatomic, strong)AVQueuePlayer *player;
@end

@implementation PlayerAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString* url = [[NSBundle mainBundle] pathForResource:@"final_video" ofType:@"mp4"];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
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
    
    AVMutableComposition* compostion = [AVMutableComposition composition];
    AVMutableCompositionTrack* trackA = [compostion addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack* trackB = [compostion addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSArray* videoTracks = @[trackA, trackB];
    
    NSArray* videoAssets = nil;
    CMTime cursorTime = kCMTimeZero;
    CMTime transitionDuration = CMTimeMake(2, 1);
    for (NSUInteger i = 0; i < videoAssets.count; i ++) {
        NSUInteger trackIndex = i % 2;
        AVMutableCompositionTrack* currentTrack = videoTracks[trackIndex];
        AVAsset* asset = videoAssets[i];
        AVAssetTrack* assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        [currentTrack insertTimeRange:timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
        cursorTime = CMTimeAdd(cursorTime, timeRange.duration);
        cursorTime = CMTimeSubtract(cursorTime, transitionDuration);
    }
}

- (void)playEnd{
    [self.item seekToTime:kCMTimeZero];
    [self.player pause];
}

- (void)applicationWillResignActive{
    [self.player pause];
}
@end
