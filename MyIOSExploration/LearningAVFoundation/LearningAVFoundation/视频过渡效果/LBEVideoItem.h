//
//  LBEVideoItem.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEMediaItem.h"
#import "LBEVideoTransition.h"

@interface LBEVideoItem : LBEMediaItem
@property (strong, nonatomic) NSArray *thumbnails;

+ (id)videoItemWithURL:(NSURL *)url;

@property (strong, nonatomic) LBEVideoTransition *startTransition;
@property (strong, nonatomic) LBEVideoTransition *endTransition;

@property (nonatomic, readonly) CMTimeRange playthroughTimeRange;
@property (nonatomic, readonly) CMTimeRange startTransitionTimeRange;
@property (nonatomic, readonly) CMTimeRange endTransitionTimeRange;

@end
