//
//  LBEAudioMixComposition.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEAudioMixComposition.h"

@interface LBEAudioMixComposition ()
@property (strong, nonatomic) AVAudioMix *audioMix;
@property (strong, nonatomic) AVComposition *composition;
@end

@implementation LBEAudioMixComposition

+ (instancetype)compositionWithComposition:(AVComposition *)composition  audioMix:(AVAudioMix *)audioMix {
    return [[self alloc] initWithComposition:composition audioMix:audioMix];
}

- (instancetype)initWithComposition:(AVComposition *)composition audioMix:(AVAudioMix *)audioMix {
    self = [super init];
    if (self) {
        _composition = composition;
        _audioMix = audioMix;
    }
    return self;
}

- (AVPlayerItem *)makePlayable {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:[self.composition copy]];
    playerItem.audioMix = self.audioMix;
    return playerItem;
}

- (AVAssetExportSession *)makeExportable {
    NSString *preset = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:[self.composition copy] presetName:preset];
    session.audioMix = self.audioMix;
    return session;
}


@end
