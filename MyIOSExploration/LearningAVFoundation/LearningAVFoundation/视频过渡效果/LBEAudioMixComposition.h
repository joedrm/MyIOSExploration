//
//  LBEAudioMixComposition.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompositionProtocol.h"

@interface LBEAudioMixComposition : NSObject <CompositionProtocol>
@property (strong, nonatomic, readonly) AVAudioMix *audioMix;
@property (strong, nonatomic, readonly) AVComposition *composition;
+ (instancetype)compositionWithComposition:(AVComposition *)composition audioMix:(AVAudioMix *)audioMix;
- (instancetype)initWithComposition:(AVComposition *)composition audioMix:(AVAudioMix *)audioMix;
@end
