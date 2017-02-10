//
//  LBETransitionComposition.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBETransitionComposition.h"

@implementation LBETransitionComposition
- (id)initWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoComposition audioMix:(AVAudioMix *)audioMix {
    if (self = [super init]) {
        _composition = composition;
        _videoComposition = videoComposition;
        _audioMix = audioMix;
    }
    return self;
}

- (AVPlayerItem *)makePlayable {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:[self.composition copy]];
    playerItem.audioMix = self.audioMix;
    playerItem.videoComposition = self.videoComposition;
    return playerItem;
}

- (AVAssetExportSession *)makeExportable {
    NSString *preset = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:[self.composition copy] presetName:preset];
    session.audioMix = self.audioMix;
    session.videoComposition = self.videoComposition;
    return session;
}

@end
