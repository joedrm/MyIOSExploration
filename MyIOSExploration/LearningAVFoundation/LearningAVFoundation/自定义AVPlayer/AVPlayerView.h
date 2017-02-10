//
//  AVPlayerView.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/1/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPlayerView : UIView
/** 需要播放的视频资源 */
@property(nonatomic,strong)NSString *urlString;
/* 包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *contrainerViewController;
/** 需要生成视频的图片数组 */
@property (nonatomic, strong) NSMutableArray* images;
@end
