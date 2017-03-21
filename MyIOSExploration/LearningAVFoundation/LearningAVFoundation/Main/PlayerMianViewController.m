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
                      @"5 视频过渡效果",
                      @"6 视频过渡效果2"
                      ];
    
    
    self.vcArr = @[
                   @"AVPlayerBasicViewController",
                   @"CustomAVPlayerViewController",
                   @"AVPlayerViewControllerDemoVC",
                   @"VideoEditViewController",
                   @"PlayerAnimationViewController",
                   @"EditVideoViewController"
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
 http://www.jianshu.com/p/9b788285b982  音视频开发Demo
 https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/03_Editing.html 官方文档
 http://blog.csdn.net/zyq522376829/article/details/52144394 官方文档翻译http://yoferzhang.com/post/20160724AVFoundation/
 https://github.com/tapharmonic/Learning-AV-Foundation  Sample code for Bob McCune's Learning AV Foundation book
 https://github.com/tapharmonic/AVFoundationDemos
 https://developer.apple.com/sample-code/wwdc/2015/
 https://www.amazon.com/Learning-Foundation-Hands-Mastering-Framework/dp/0321961803   Book <<Learning AV Foundation>> sell
 https://github.com/jkyin/Subtitle
 https://github.com/rFlex/SCRecorder
 
 // iOS平台上编码之CMTime，CMTimeMake，CMTimeMakeWithSeconds的作用
 http://depthlove.github.io/2016/03/15/CMTime-CMTimeMake-CMTimeMakeWithSeconds-in-iOS-encode/
 
 https://developer.apple.com/library/content/samplecode/AVSimpleEditoriOS/Introduction/Intro.html  官方视频编辑Demo
 https://www.raywenderlich.com/13418/how-to-play-record-edit-videos-in-ios
 https://www.raywenderlich.com/30200/avfoundation-tutorial-adding-overlays-and-animations-to-videos
 http://www.cocoachina.com/ios/20141208/10542.html  视频特效制作：如何给视频添加边框、水印、动画以及3D效果
 https://github.com/zangqilong198812/VideoPushDemo  视频特效制作：如何给视频添加边框、水印、动画以及3D效果 Demo
 https://github.com/HarrisonJackson/HJImagesToVideo  图片生成视频
 https://github.com/MarineXmh/ImageToVideo 一张或多张图片和声音合成视频
 https://github.com/cruisingFish/VideoService  集成视频播放过程中一些常用的功能，例如视频合成、视频添加水印、获取视频时间长度、获取视频大小、获取视频缩略图、获取视频某一帧图片
 https://github.com/MuFengYi/MovieMergeAddEffect
 https://github.com/ismilesky/MaxVideo  多张图片合成视频；多个小视频合成大视频
 https://github.com/100mango/zen/tree/master/iOS%E5%AD%A6%E4%B9%A0%EF%BC%9AAVFoundation%20%E8%A7%86%E9%A2%91%E6%B5%81%E5%A4%84%E7%90%86 iOS学习：AVFoundation 视频流处理
 http://www.superqq.com/blog/2015/08/24/avfoundation-gpuimage-find/ AVFoundation和 GPUImage初探
 http://wiki.baixin.io/2016/07/22/%E8%A7%86%E9%A2%91%E8%B5%84%E6%96%99/   iOS视频开发资料
 https://github.com/12207480/TYVideoPlayer     封装了AVPlayer的视频播放器组件，支持点播，直播和本地播放
 https://github.com/xujingzhou/CustomVideo   美拍,秒拍功能大拆解, 以及功能大扩展。
 https://github.com/xujingzhou/FunCrop  将指定视频，按算法进行水平或垂直切分，并加入多种转场动画后输出
 http://v.youku.com/v_show/id_XNDUyMjI3MTY0.html 斯坦福ios教程 Introduction to AVFoundation
 http://www.ishare5.com/10076923/
 
 
 https://github.com/hagaiw/AVVideoCompositionOptimizationRadar  使用滤镜来编辑视频
 https://github.com/531464049/GPIImageVideoEdit  使用 GOUImage 给视频添加滤镜（本地或实时拍摄）
 
 
 
 https://github.com/loyinglin/LearnAVFoundation 
 
 https://github.com/ElfSundae/AVDemo  Demo projects for iOS Audio & Video development **** 
 
 视音频编解码技术零基础学习方法
 http://blog.csdn.net/leixiaohua1020/article/details/18893769
 
 开源框架：
 https://github.com/vimeo/VIMVideoPlayer
 https://github.com/mobileplayer/mobileplayer-ios
 https://github.com/piemonte/PBJVideoPlayer
 
 开源APP
 https://github.com/Onix-Systems/ios-video-maker  一个上线的图片、视频编辑的APP，强烈推荐
 https://github.com/SinglTown/HappyMovie
 https://github.com/SYH07088/DBMovie
 https://github.com/xujingzhou/FunVideo
 https://github.com/xujingzhou/CustomVideo
 https://github.com/GrayJIAXU/520Linkee  实现了作为一个直播App的基本功能，比如本地视频流采集、播放、美颜、礼物、点赞出心等
 */


/*
 IOS 播放器开发：
 谈一谈做iOS播放器库开发所涉及的知识点：
 
 要开发一套属于自己的播放器库，不利用移动设备上自带的播放器来播放音频、视频，要用到哪些知识点呢，下面以我熟悉公司播放器库的前提下，说一说我的看法。
 
 任何客户端只要跟服务器打交道，少不了通讯协议。音视频这块涉及的实时流相关协议很多，有RTSP、RTMP、MMS、HLS、RTP、RTCP、SDP、TCP、UDP、HTTP等。
 
 客户端从服务器上获取到的音视频数据，要知道容器与编码方式的区别，封装音视频数据的容器类型主要有AVI (*.avi)、MPG (*.mpg/*.mpeg/*.dat)、VOB (*.vob)、MP4、3GP、ASF (*.wmv/*.asf)
 、RM (*.rm/*.rmvb)、MOV (*.mov)、MKV
 、WAV、TS。
 
 客户端从服务器上获取到了音视频数据，该如何进行解码显示，首先要知道音频、视频的的编码方式，客户端要显示音视频数据需要根据编码的方式进行相应的解码操作，目前常见的编码类型有MPEG系列、H.26X系列、微软windows media系列、Real Media系列、QuickTime系列。
 
 上面说到了一些流媒体协议、流媒体数据的封装类型以及编码方式。而我们要做一款播放器首先是要对以上知识要了解的。
 
 公司的业务涉及最多的是rtsp这块。服务器端为rtsp流媒体服务器，客户端也就是播放器库采用FFMpeg进行解码、OPenGL ES进行YUV视频数据渲染。
 
 播放器库与服务器端进行交互，涉及到RTSP协议的请求，传输层协议采用的TCP、UDP协议，所以要对TCP连接的三次握手要熟悉，这其中也就涉及到网络编程中的SOCKET编程知识了，BSD socket编程是需要掌握的。
 
 播放器库对从服务器上请求到的音频、视频rtp包，要进行解包，就是去掉一些协议的头获取到音视频数据段。获取到这些数据后，不能直接播放，需要进行解码操作。视频解码出来一般为Planar 4:2:0 YUV格式。要显示YUV视频图像就需要利用OPenGL ES进行渲染了。
 
 播放器在工作时，视频数据要进行解码放入数据缓存区，数据缓存区的解码后的数据被取出交给OpenGL进行渲染，所以多线程是必不可少的环节了。开辟2个线程，一个线程进行解码处理，另一个线程进行视频数据的渲染。多线程中常使用的是POSIX thread多线程编程。
 
 虽然开发的iOS播放器库，但是底层的东西大部分是c语言的东西，比如用到开源库FFMpeg，以及一些上层的对FFMpeg的封装，数据缓存区，所以c语言和数据结构的基础要扎实，什么函数指针，内存分配与管理，数据结构中的单链表那得玩得比较溜。
 
 总结一下，需要具备的知识有
 
 rtsp、sdp、tcp、udp、ip协议（rtsp的DESCRIBE、OPTION、SETUP、PLAY、PAUSE、TEARDOWN；tcp连接的三次握手／断开的四次握手）
 socket（bsd socket）
 多线程（posix thread）
 opengl es
 FFMpeg（知道用它来解码）
 YUV420（知道它的原理与格式）
 音视频同步（时间戳的处理）
 c语言指针（void *、函数指针、回调函数）
 内存管理（堆区、栈区、静态区、内存对齐）
 数据结构（单链表）
 
 参考资料：
 http://www.cnblogs.com/sunminmin/category/686553.html 
 http://www.cnblogs.com/sunminmin/p/4463741.html  实战FFmpeg－－编译iOS平台使用的FFmpeg库（支持arm64的FFmpeg2.6.2）
 http://www.cnblogs.com/sunminmin/p/4466448.html  实战FFmpeg－－iOS平台使用FFmpeg将视频文件转换为YUV文件
 http://www.cnblogs.com/sunminmin/category/686553.html  实战FFmpeg + OpenGLES－－iOS平台使用OpenGLES渲染YUV图片
 http://www.cnblogs.com/sunminmin/p/4469617.html  实战FFmpeg + OpenGLES－－iOS平台上视频解码和播放
 
 
 */









