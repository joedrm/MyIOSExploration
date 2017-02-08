//
//  LBETimeline.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LBETrack) {
    LBEVideoTrack = 0,
    LBETitleTrack,
    LBECommentaryTrack,
    LBEMusicTrack
};


@interface LBETimeline : NSObject
@property (strong, nonatomic) NSArray *videos;
@property (strong, nonatomic) NSArray *transitions;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *voiceOvers;
@property (strong, nonatomic) NSArray *musicItems;

- (BOOL)isSimpleTimeline;
@end
