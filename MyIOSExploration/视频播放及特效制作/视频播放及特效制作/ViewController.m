//
//  ViewController.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/1/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

/* 参考资料：

 https://www.raywenderlich.com/30200/avfoundation-tutorial-adding-overlays-and-animations-to-videos
 http://www.cocoachina.com/ios/20141208/10542.html  视频特效制作：如何给视频添加边框、水印、动画以及3D效果
 https://github.com/zangqilong198812/VideoPushDemo  视频特效制作：如何给视频添加边框、水印、动画以及3D效果 Demo
 https://github.com/HarrisonJackson/HJImagesToVideo  图片生成视频
 https://github.com/MarineXmh/ImageToVideo 一张或多张图片和声音合成视频
 https://github.com/cruisingFish/VideoService  集成视频播放过程中一些常用的功能，例如视频合成、视频添加水印、获取视频时间长度、获取视频大小、获取视频缩略图、获取视频某一帧图片
 https://github.com/ismilesky/MaxVideo  多张图片合成视频；多个小视频合成大视频
 https://github.com/100mango/zen/tree/master/iOS%E5%AD%A6%E4%B9%A0%EF%BC%9AAVFoundation%20%E8%A7%86%E9%A2%91%E6%B5%81%E5%A4%84%E7%90%86 iOS学习：AVFoundation 视频流处理
 */

#import "ViewController.h"
#import "AVPlayerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVPlayerView* playerView = [[AVPlayerView alloc] init];
    playerView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 200);
    playerView.urlString = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
    playerView.contrainerViewController = self;
    [self.view addSubview:playerView];
    
}


@end
