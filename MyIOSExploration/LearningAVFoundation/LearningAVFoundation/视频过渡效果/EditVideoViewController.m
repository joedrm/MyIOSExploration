//
//  EditVideoViewController.m
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/10.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "EditVideoViewController.h"
#import "SimpleEditor.h"
#import "VideoMaker.h"

@interface EditVideoViewController ()
@property (nonatomic, strong) SimpleEditor		*editor;
@property (nonatomic, strong) NSMutableArray   *clips;
@property (nonatomic, strong) NSMutableArray	*clipTimeRanges;
@property (nonatomic, assign) float  transitionDuration;
@property (nonatomic, assign) BOOL	   transitionsEnabled;
@property (nonatomic, strong)AVPlayerItem *item;
@property (nonatomic, strong)AVQueuePlayer *player;
@end

@implementation EditVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.editor = [[SimpleEditor alloc] init];
    self.clips = [[NSMutableArray alloc] init];
    self.clipTimeRanges = [[NSMutableArray alloc] init];
    
    self.transitionDuration = 2.0; // 默认变换时间
    self.transitionsEnabled = YES;
    
    
    
    
     [self setupEditingAndPlayback];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    btn.center = self.view.center;
    [btn setBackgroundColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addActionHandler:^{
       [self.editor beginExport];
    }];
}

- (void)setupEditingAndPlayback
{
//    NSArray* videoNameArr = @[@"20170208142618078",@"20170208142618099", @"20170208142618101"];
    
    AVAsset* asset1 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:kImage(@"image1.jpg")]];
    AVAsset* asset2 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:kImage(@"image2.jpg")]];
    AVAsset* asset3 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:kImage(@"image3.jpg")]];
    AVAsset* asset4 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:kImage(@"image4.jpg")]];
//    AVAsset* asset5 = [AVAsset assetWithURL:[VideoMaker createVideoWithImage:kImage(@"image5.jpg")]];
    
//    AVURLAsset *asset3 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"abc" ofType:@"mp4"]]];
//    AVURLAsset *asset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"qwe" ofType:@"mp4"]]];
//    AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"eer" ofType:@"mp4"]]];
    
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    NSArray *assetKeysToLoadAndTest = @[@"tracks", @"duration", @"composable"];
    
    // 加载视频
    [self loadAsset:asset1 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset2 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset3 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    [self loadAsset:asset4 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
//    [self loadAsset:asset5 withKeys:assetKeysToLoadAndTest usingDispatchGroup:dispatchGroup];
    
    // 等待就绪
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self synchronizeWithEditor];
    });
}

- (void)loadAsset:(AVAsset *)asset withKeys:(NSArray *)assetKeysToLoad usingDispatchGroup:(dispatch_group_t)dispatchGroup
{
//    [self.clips addObject:asset];
//    [self.clipTimeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(5, 1))]];
    dispatch_group_enter(dispatchGroup);
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoad completionHandler:^(){
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
        
        NSLog(@"%@,%@", @(CMTimeGetSeconds(asset.duration)), @(bSuccess));
        if (bSuccess && CMTimeGetSeconds(asset.duration) > 3) {
            [self.clips addObject:asset];
            [self.clipTimeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), CMTimeMakeWithSeconds(4, 1))]];
        }
        else {
            NSLog(@"error ");
        }
        dispatch_group_leave(dispatchGroup);
    }];
}
- (void)synchronizeWithEditor
{
    // Clips
    [self synchronizeEditorClipsWithOurClips];
    [self synchronizeEditorClipTimeRangesWithOurClipTimeRanges];
    
    
    // Transitions
//    if (_transitionsEnabled) {
        self.editor.transitionDuration = CMTimeMakeWithSeconds(_transitionDuration, 600);
//    } else {
//        self.editor.transitionDuration = kCMTimeInvalid;
//    }
    self.editor.transitionType = (EditorTransitionType*)malloc(sizeof(int) * self.editor.clips.count);
    self.editor.transitionType[0] = EditorTransitionTypePush;
    self.editor.transitionType[1] = EditorTransitionTypeCrossFade;
    self.editor.transitionType[2] = EditorTransitionTypeCustom;
    self.editor.transitionType[3] = EditorTransitionTypeCrossFade;
    self.editor.transitionType[4] = EditorTransitionTypeCustom;
    [self.editor buildCompositionObjectsForPlayback];
//    [self play];
}


- (void)play{
    AVQueuePlayer *player = [AVQueuePlayer playerWithPlayerItem:self.editor.playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = player;
    vc.view.frame = CGRectMake(0, 200, kScreenWidth, 300);
    vc.view.backgroundColor = [UIColor blackColor];
    vc.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view addSubview:vc.view];
    
    [player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
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


- (void)synchronizeEditorClipsWithOurClips
{
    NSMutableArray *validClips = [NSMutableArray array];
    for (AVURLAsset *asset in self.clips) {
        if (![asset isKindOfClass:[NSNull class]]) {
            [validClips addObject:asset];
        }
    }
    
    self.editor.clips = validClips;
}
- (void)synchronizeEditorClipTimeRangesWithOurClipTimeRanges
{
    NSMutableArray *validClipTimeRanges = [NSMutableArray array];
    for (NSValue *timeRange in self.clipTimeRanges) {
        if (! [timeRange isKindOfClass:[NSNull class]]) {
            [validClipTimeRanges addObject:timeRange];
        }
    }
    self.editor.clipTimeRanges = validClipTimeRanges;
}
@end
