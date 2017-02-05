//
//  CustomAVPlayerViewController.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/3.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CustomAVPlayerViewController.h"
#import "AVPlayerView.h"

@interface CustomAVPlayerViewController ()

@end

@implementation CustomAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
