//
//  ViewController.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/1/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

/* 参考资料：
 https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/03_Editing.html 官方文档
 http://blog.csdn.net/zyq522376829/article/details/52144394 官方文档翻译
 https://developer.apple.com/library/content/samplecode/AVSimpleEditoriOS/Introduction/Intro.html  官方视频编辑Demo
 https://www.raywenderlich.com/13418/how-to-play-record-edit-videos-in-ios
 https://www.raywenderlich.com/30200/avfoundation-tutorial-adding-overlays-and-animations-to-videos
 http://www.cocoachina.com/ios/20141208/10542.html  视频特效制作：如何给视频添加边框、水印、动画以及3D效果
 https://github.com/zangqilong198812/VideoPushDemo  视频特效制作：如何给视频添加边框、水印、动画以及3D效果 Demo
 https://github.com/HarrisonJackson/HJImagesToVideo  图片生成视频
 https://github.com/MarineXmh/ImageToVideo 一张或多张图片和声音合成视频
 https://github.com/cruisingFish/VideoService  集成视频播放过程中一些常用的功能，例如视频合成、视频添加水印、获取视频时间长度、获取视频大小、获取视频缩略图、获取视频某一帧图片
 https://github.com/ismilesky/MaxVideo  多张图片合成视频；多个小视频合成大视频
 https://github.com/100mango/zen/tree/master/iOS%E5%AD%A6%E4%B9%A0%EF%BC%9AAVFoundation%20%E8%A7%86%E9%A2%91%E6%B5%81%E5%A4%84%E7%90%86 iOS学习：AVFoundation 视频流处理
 http://www.superqq.com/blog/2015/08/24/avfoundation-gpuimage-find/ AVFoundation和 GPUImage初探
 http://wiki.baixin.io/2016/07/22/%E8%A7%86%E9%A2%91%E8%B5%84%E6%96%99/   iOS视频开发资料
 */

#import "ViewController.h"
#import "AVPlayerView.h"
#import <AVKit/AVKit.h>  // 框架
#import <AVFoundation/AVFoundation.h>  // AVPlayer

@interface ViewController ()<AVPlayerViewControllerDelegate>
@property (nonatomic,strong)AVPlayerViewController *AVPlayerVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


/*
 视频处理主要是用到以下这几个类
 AVMutableComposition:      可以用来操作音频和视频的组合
 AVMutableVideoComposition: 可以用来对视频进行操作
 AVMutableAudioMix:         给视频添加音频的
 AVMutableVideoCompositionInstruction: 和AVMutableVideoCompositionLayerInstruction 一般都是配合使用，用来给视频添加水印或者旋转视频方向，
 AVMutableVideoCompositionLayerInstruction
 AVAssetExportSession:      用来进行视频导出操作的
 
 */








#pragma mark - 自定义的播放器
- (void)customPlayer{

    AVPlayerView* playerView = [[AVPlayerView alloc] init];
    playerView.urlString = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
    playerView.contrainerViewController = self;
    [self.view addSubview:playerView];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
        make.top.mas_equalTo(kStatusBarAndNavigationBarHeight);
    }];
}

#pragma mark - 使用系统的播放器
- (IBAction)AVPlayerViewController:(UIButton *)sender {
    AVPlayerViewController *vc = [[AVPlayerViewController alloc]init];
    self.AVPlayerVC = vc;
    vc.delegate = self;
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"1.mp4" ofType:nil];
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];//[NSURL fileURLWithPath:path];
    // 创建播放器
    AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
    vc.player = player;
    // 是否显示控制按钮
    //vc.showsPlaybackControls = NO;
    [player play];
    [self presentViewController:vc animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

// 接收到通知会来到此方法 (效果：切换下一个视频)
- (void)didPlayToEndTime{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"2.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
    [player play];
    self.AVPlayerVC.player  = player;
}

#pragma mark - AVPlayerViewControllerDelegate代理方法（对用户画中画的操作进行监听）
// 将要开始画中画时调用的方法
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"1将要开始画中画");
}

// 已经开始画中画时调用的方法
- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"2已经开始画中画");
}

// 开启画中画失败调用的方法
- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error{
    NSLog(@"3开启画中画失败调");
}

// 将要停止画中画时调用的方法
- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"4将要停止画中画");
}

// 已经停止画中画时调用的方法
- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController{
    NSLog(@"5已经停止画中画");
}

// 是否在开始画中画时自动将当前的播放界面dismiss掉 返回YES则自动dismiss 返回NO则不会自动dismiss
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController{
    NSLog(@"6自动将当前的播放界面dismiss掉");
    return YES;
}

// 用户点击还原按钮，从画中画模式还原回app内嵌模式时调用的方法
- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler{
    NSLog(@"7从画中画模式还原回app内嵌模式");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
