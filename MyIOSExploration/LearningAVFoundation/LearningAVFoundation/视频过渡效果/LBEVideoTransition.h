//
//  LBEVideoTransition.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LBEVideoTransitionTypeNone,
    LBEVideoTransitionTypeDissolve,
    LBEVideoTransitionTypePush,
    LBEVideoTransitionTypeWipe
} LBEVideoTransitionType;

typedef enum {
    LBEPushTransitionDirectionLeftToRight = 0,
    LBEPushTransitionDirectionRightToLeft,
    LBEPushTransitionDirectionTopToButton,
    LBEPushTransitionDirectionBottomToTop,
    LBEPushTransitionDirectionInvalid = INT_MAX
} LBEPushTransitionDirection;


@interface LBEVideoTransition : NSObject

+ (id)videoTransition;

@property (nonatomic) LBEVideoTransitionType type;
@property (nonatomic) CMTimeRange timeRange;
@property (nonatomic) CMTime duration;
@property (nonatomic) LBEPushTransitionDirection direction;

#pragma mark - Convenience initializers for stock transitions

+ (id)disolveTransitionWithDuration:(CMTime)duration;
+ (id)pushTransitionWiLBEDuration:(CMTime)duration direction:(LBEPushTransitionDirection)direction;



@end
