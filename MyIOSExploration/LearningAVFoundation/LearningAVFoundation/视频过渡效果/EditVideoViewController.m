//
//  EditVideoViewController.m
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/15.
//  Copyright © 2017年 wdy. All rights reserved.
/*
 https://github.com/jiang6777/Video_Edit  视频合并，编辑，裁剪，添加水印，添加背景音乐
 
 */

#import "EditVideoViewController.h"
#import "SimpleEditor.h"
#import "VideoMaker.h"
#import <WDYBaseProject/UIImage+SubImage.h>

#import "VideoEffect.h"
#import "VideoThemes.h"
#import "VideoThemesData.h"
#import "VideoBuilder.h"
#import "PBJVideoPlayerController.h"
#import "CDPVideoEditor.h"

@interface EditVideoViewController ()<PBJVideoPlayerControllerDelegate,ExportProgressDelegate>
@property (weak, nonatomic) IBOutlet UIView *playerContainerView;
@property (nonatomic, strong) SimpleEditor		*editor;
@property (nonatomic, strong) NSMutableArray   *clips;
@property (nonatomic, strong) NSMutableArray	*clipTimeRanges;
@property (nonatomic, assign) float  transitionDuration;
@property (nonatomic, assign) BOOL	   transitionsEnabled;
@property (nonatomic, strong)AVPlayerItem *item;
@property (nonatomic, strong)AVQueuePlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (weak, nonatomic) IBOutlet UIButton *borderButton;
@property (weak, nonatomic) IBOutlet UIButton *layerButton;
@property (strong, nonatomic) PBJVideoPlayerController* videoPlayerController;
@end

@implementation EditVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.editor = [[SimpleEditor alloc] init];
    self.clips = [[NSMutableArray alloc] init];
    self.clipTimeRanges = [[NSMutableArray alloc] init];
    
    [self initVideoPlayer];
    [self setupEditingAndPlayback];
}

#pragma mark - PBJVideoPlayerControllerDelegate
- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    
}


- (void)setupEditingAndPlayback
{
    CGSize imageSize = CGSizeMake(640, 480);
    AVAsset* asset1 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:[kImage(@"image1.jpg") getTiledImageWithSize:imageSize]]];
    AVAsset* asset2 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:[kImage(@"image2.jpg") getTiledImageWithSize:imageSize]]];
    AVAsset* asset3 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:[kImage(@"image3.jpg") getTiledImageWithSize:imageSize]]];
    AVAsset* asset4 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:[kImage(@"image4.jpg") getTiledImageWithSize:imageSize]]];
    AVAsset* asset5 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:[kImage(@"image5.jpg") getTiledImageWithSize:imageSize]]];
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *assetKeysToLoadAndTest = @[@"tracks", @"duration", @"composable"];
    
    // 加载视频
    [self loadAsset:asset1 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset2 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset3 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset4 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset5 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    
    // 等待就绪
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self synchronizeWithEditor];
    });
}

- (UIImage*)dealImage:(UIImage*)sourceImage WithSize:(CGSize)targetSize{

    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"could not scale image");
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)loadAsset:(AVAsset *)asset withKeys:(NSArray *)assetKeysToLoad usingDispatchGroup:(dispatch_group_t)dispatchGroup
{
    dispatch_group_enter(dispatchGroup);
    kWeakSelf(self)
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoad completionHandler:^(){
        kStrongSelf(self)
        // 测试是否成功加载
        BOOL bSuccess = YES;
        for (NSString *key in assetKeysToLoad) {
            NSError *error;
            if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                NSLog(@"Key value loading failed for key:%@ with error: %@", key, error);
                bSuccess = NO;
                break;
            }
        }
        if (![asset isComposable]) {
            NSLog(@"Asset is not composable");
            bSuccess = NO;
        }
        
        if (bSuccess && CMTimeGetSeconds(asset.duration) > 3) {
            
            float assetDurtion = CMTimeGetSeconds(asset.duration);
            CMTime startTime = CMTimeMakeWithSeconds(0, 1);
            CMTime endTime = CMTimeMakeWithSeconds(assetDurtion, 1);
            CMTimeRange timeRange = CMTimeRangeMake(startTime, endTime);
            NSValue *value = [NSValue valueWithCMTimeRange:timeRange];
            
            NSLog(@"asset.duration = %@, bSuccess = %@, value = %@", @(assetDurtion), @(bSuccess), value);
            
            [self.clips addObject:asset];
            [self.clipTimeRanges addObject:value];
        } else {
            NSLog(@"error ");
        }
        dispatch_group_leave(dispatchGroup);
    }];
}
- (void)synchronizeWithEditor
{
    NSMutableArray *validClips = [NSMutableArray array];
    for (AVURLAsset *asset in self.clips) {
        if (![asset isKindOfClass:[NSNull class]]) {
            [validClips addObject:asset];
        }
    }
    
    NSMutableArray *validClipTimeRanges = [NSMutableArray array];
    for (NSValue *timeRange in self.clipTimeRanges) {
        if (! [timeRange isKindOfClass:[NSNull class]]) {
            [validClipTimeRanges addObject:timeRange];
        }
    }
    self.editor.delegate = self;
    self.editor.clips = validClips;
    self.editor.clipTimeRanges = validClipTimeRanges;
    self.editor.transitionDuration = CMTimeMakeWithSeconds(1.0, 600);
    self.editor.transitionType = (VideoTransitionType*)malloc(sizeof(int) * self.editor.clips.count);
    for (int i = 0; i < self.editor.clips.count; i ++) {
        self.editor.transitionType[i] = [self getRandomNumber:VideoTransitionTypeFadeIn to:VideoTransitionTypeWipe];
    }
    [self.editor buildCompositionObjectsForPlayback];
    [self.editor addVoiceEffectsWithAudioPath:@"The Day You Went Away"];
    [TipsView showLoading:@"制作中..."];
    [self.editor exportSaveToLibrary:NO exportSuccessed:^(NSString* pathStr,BOOL isExportSuccessed) {
        NSLog(@"isExportSuccessed = %@ pathStr = %@", @(isExportSuccessed), pathStr);
        [TipsView hideToastView];
        if (isExportSuccessed) {
            self.videoPlayerController.videoPath = pathStr;
            [self.videoPlayerController playFromBeginning];
        }
    }];
    
}

#pragma mark - ExportProgressDelegate

- (void)exportVideoProgress:(float)progress{
    
    NSLog(@"progress = %.2f", progress);
    
}

- (void)initVideoPlayer{

    PBJVideoPlayerController* videoPlayerController = [[PBJVideoPlayerController alloc] init];
    videoPlayerController.delegate = self;
    videoPlayerController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.4);
    videoPlayerController.view.clipsToBounds = YES;
    videoPlayerController.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:videoPlayerController];
    [self.playerContainerView addSubview:videoPlayerController.view];
    self.videoPlayerController = videoPlayerController;
}


-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (NSString*)getOutputFilePath
{
    NSString *path = @"Masterpiece.mp4";
    NSString* mp4OutputFile = [NSTemporaryDirectory() stringByAppendingPathComponent:path];
    return mp4OutputFile;
}


- (void)playVideo{
    AVQueuePlayer *player = [AVQueuePlayer playerWithPlayerItem:self.editor.playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = player;
    vc.view.frame = self.playerContainerView.bounds;
    vc.view.backgroundColor = [UIColor blackColor];
    vc.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerContainerView addSubview:vc.view];
    [player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    self.item = self.editor.playerItem;
    self.player = player;
}

- (void)playEnd{
    [self.item seekToTime:kCMTimeZero];
    [self.player pause];
}

- (void)applicationWillResignActive{
    [self.player pause];
}

- (void)dealloc{
    
    NSLog(@"%s", __func__);
}


/**
 添加声音特效
 */
- (IBAction)voiceAction:(UIButton *)sender {
    
    if (self.videoPlayerController.playbackState == PBJVideoPlayerPlaybackStatePlaying)
    {
        [self.videoPlayerController pause];
    }
    for (int i = 0; i < self.editor.clips.count; i ++) {
        self.editor.transitionType[i] = [self getRandomNumber:VideoTransitionTypeFadeIn to:VideoTransitionTypeWipe];
    }
    [TipsView showLoading:@"制作中..."];
    [self.editor buildCompositionObjectsForPlayback];
    [self.editor addVoiceEffectsWithAudioPath:@"Big Big World"];
    [self.editor exportSaveToLibrary:NO exportSuccessed:^(NSString* pathStr,BOOL isExportSuccessed) {
        [TipsView hideToastView];
        NSLog(@"isExportSuccessed = %@ pathStr = %@", @(isExportSuccessed), pathStr);
        if (isExportSuccessed) {
            self.videoPlayerController.videoPath = pathStr;
            [self.videoPlayerController playFromBeginning];
        }
    }];
}

/**
 添加边框特效
 */
- (IBAction)borderAction:(UIButton *)sender {
    
    
    
    
}

/**
 添加图层特效
 */
- (IBAction)layerAction:(UIButton *)sender {
    
}


@end
