//
//  PlayerMianViewController.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/3.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PlayerMianViewController.h"

@interface PlayerMianViewController ()

@end

@implementation PlayerMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"视频播放及特效制作";
    self.titleArr = @[
                      @"1 AVPlayer基本使用",
                      @"2 自定义AVPlayer",
                      @"3 AVPlayerViewController的使用",
                      @"4 视频编辑",
                      @"5 视频过渡效果"
                      ];
    
    
    self.vcArr = @[
                   @"AVPlayerBasicViewController",
                   @"CustomAVPlayerViewController",
                   @"AVPlayerViewControllerDemoVC",
                   @"VideoEditViewController",
                   @"PlayerAnimationViewController"
                   ];
    
}

@end

/*
 视频处理主要是用到以下这几个类
 AVMutableComposition:      可以用来操作音频和视频的组合
 AVMutableVideoComposition: 可以用来对视频进行操作
 AVMutableAudioMix:         给视频添加音频的
 AVMutableVideoCompositionInstruction: 和AVMutableVideoCompositionLayerInstruction 一般都是配合使用，用来给视频添加水印或者旋转视频方向，
 AVMutableVideoCompositionLayerInstruction
 AVAssetExportSession:      用来进行视频导出操作的
 
 */


/* 参考资料：
 https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/03_Editing.html 官方文档
 http://blog.csdn.net/zyq522376829/article/details/52144394 官方文档翻译http://yoferzhang.com/post/20160724AVFoundation/
 https://github.com/tapharmonic/Learning-AV-Foundation  Sample code for Bob McCune's Learning AV Foundation book
 https://github.com/tapharmonic/AVFoundationDemos
 https://developer.apple.com/sample-code/wwdc/2015/
 https://www.amazon.com/Learning-Foundation-Hands-Mastering-Framework/dp/0321961803   Book <<Learning AV Foundation>> sell
 https://github.com/jkyin/Subtitle
 
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
 https://github.com/12207480/TYVideoPlayer     封装了AVPlayer的视频播放器组件，支持点播，直播和本地播放
 https://github.com/xujingzhou/CustomVideo   美拍,秒拍功能大拆解, 以及功能大扩展。
 https://github.com/xujingzhou/FunCrop  将指定视频，按算法进行水平或垂直切分，并加入多种转场动画后输出
 http://v.youku.com/v_show/id_XNDUyMjI3MTY0.html 斯坦福ios教程 Introduction to AVFoundation
 http://www.ishare5.com/10076923/
 */
