//
//  CompositionBuilderProtocol.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//



#import <AVFoundation/AVFoundation.h>
#import "CompositionProtocol.h"

@protocol CompositionBuilderProtocol <NSObject>

- (id <CompositionProtocol>)buildComposition;

@end
