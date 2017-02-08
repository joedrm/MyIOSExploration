//
//  LBEMediaItem.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBETimelineItem.h"

typedef void(^LBEPreparationCompletionBlock)(BOOL complete);

@interface LBEMediaItem : LBETimelineItem

@property (strong, nonatomic) AVAsset *asset;
@property (nonatomic, readonly) BOOL prepared;
@property (nonatomic, readonly) NSString *mediaType;
@property (nonatomic, copy, readonly) NSString *title;

- (id)initWithURL:(NSURL *)url;

- (void)prepareWithCompletionBlock:(LBEPreparationCompletionBlock)completionBlock;

- (void)performPostPrepareActionsWithCompletionBlock:(LBEPreparationCompletionBlock)completionBlock;

- (BOOL)isTrimmed;

- (AVPlayerItem *)makePlayable;

@end
