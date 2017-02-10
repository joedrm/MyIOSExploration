//
//  LBEVideoTransition.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEVideoTransition.h"

@implementation LBEVideoTransition

+ (id)videoTransition {
    return [[[self class] alloc] init];
}

+ (id)disolveTransitionWithDuration:(CMTime)duration {
    LBEVideoTransition *transition = [self videoTransition];
    transition.type = LBEVideoTransitionTypePush;
    transition.duration = duration;
    return transition;
}

+ (id)pushTransitionWiLBEDuration:(CMTime)duration direction:(LBEPushTransitionDirection)direction {
    LBEVideoTransition *transition = [self videoTransition];
    transition.type = LBEVideoTransitionTypePush;
    transition.duration = duration;
    transition.direction = direction;
    return transition;
}


- (id)init {
    self = [super init];
    if (self) {
        _type = LBEVideoTransitionTypePush;
        _timeRange = kCMTimeRangeInvalid;
    }
    return self;
}

- (void)setDirection:(LBEPushTransitionDirection)direction {
    if (self.type == LBEVideoTransitionTypePush) {
        _direction = direction;
    } else {
        _direction = LBEPushTransitionDirectionInvalid;
        NSAssert(NO, @"Direction can only be specified for a type == LBEVideoTransitionTypePush.");
    }
}


@end
