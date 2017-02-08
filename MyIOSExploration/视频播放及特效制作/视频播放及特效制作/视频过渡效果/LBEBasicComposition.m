//
//  LBEBasicComposition.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEBasicComposition.h"

@interface LBEBasicComposition ()
@property (strong, nonatomic) AVComposition *composition;
@end

@implementation LBEBasicComposition

+ (id)compositionWithComposition:(AVComposition *)composition {
    return [[self alloc] initWithComposition:composition];
}

- (id)initWithComposition:(AVComposition *)composition {
    self = [super init];
    if (self) {
        _composition = composition;
    }
    return self;
}

- (AVPlayerItem *)makePlayable {
    return [AVPlayerItem playerItemWithAsset:[self.composition copy]];
}

- (AVAssetExportSession *)makeExportable {
    return [AVAssetExportSession exportSessionWithAsset:[self.composition copy] presetName:AVAssetExportPresetHighestQuality];
}

@end
