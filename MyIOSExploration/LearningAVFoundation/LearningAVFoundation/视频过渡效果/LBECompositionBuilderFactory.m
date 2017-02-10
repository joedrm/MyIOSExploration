//
//  LBECompositionBuilderFactory.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBECompositionBuilderFactory.h"
#import "LBEBasicCompositionBuilder.h"
#import "LBETransitionCompositionBuilder.h"

@implementation LBECompositionBuilderFactory

- (id <CompositionBuilderProtocol>)builderForTimeline:(LBETimeline *)timeline {
    if ([timeline isSimpleTimeline]) {
        return [[LBEBasicCompositionBuilder alloc] initWithTimeline:timeline];
    } else {
        return [[LBETransitionCompositionBuilder alloc] initWithTimeline:timeline];
    }
}


@end
