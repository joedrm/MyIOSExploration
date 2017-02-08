//
//  LBETransitionComposition.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompositionProtocol.h"

@interface LBETransitionComposition : NSObject<CompositionProtocol>

@property (strong, nonatomic, readonly) AVComposition *composition;
@property (strong, nonatomic, readonly) AVVideoComposition *videoComposition;
@property (strong, nonatomic, readonly) AVAudioMix *audioMix;

- (id)initWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoComposition  audioMix:(AVAudioMix *)audioMix;
@end
