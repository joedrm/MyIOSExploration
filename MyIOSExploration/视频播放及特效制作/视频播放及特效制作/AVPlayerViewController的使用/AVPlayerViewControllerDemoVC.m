//
//  AVPlayerViewControllerDemoVC.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/3.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AVPlayerViewControllerDemoVC.h"

@interface AVPlayerViewControllerDemoVC ()

@property (nonatomic,strong)AVPlayerViewController *AVPlayerVC;
@end

@implementation AVPlayerViewControllerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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



@end
