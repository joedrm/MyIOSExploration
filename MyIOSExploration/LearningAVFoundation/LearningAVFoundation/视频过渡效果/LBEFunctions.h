//
//  LBEFunctions.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#ifndef LBEFunctions_h
#define LBEFunctions_h

static const CGFloat LBETimelineSeconds = 12.0f;
static const CGFloat LBETimelineWidth = 1014.0f;

static const CMTime LBEDefaultFadeInOutTime = {3, 2, 1, 0}; // 1.5 seconds
static const CMTime LBEDefaultDuckingFadeInOutTime = {1, 2, 1, 0}; // .5 seconds
static const CMTime LBEDefaultTransitionDuration = {1, 1, 1, 0}; // 1 second

static inline BOOL LBEIsEmpty(id value) {
    return value == nil ||
    value == [NSNull null] ||
    ([value isKindOfClass:[NSString class]] && [value length] == 0) ||
    ([value respondsToSelector:@selector(count)] && [value count] == 0);
}

static inline CGFloat LBEGetWidthForTimeRange(CMTimeRange timeRange, CGFloat scaleFactor) {
    return CMTimeGetSeconds(timeRange.duration) * scaleFactor;
}

static inline CGPoint LBEGetOriginForTime(CMTime time) {
    if (CMTIME_IS_VALID(time)) {
        CGFloat seconds = CMTimeGetSeconds(time);
        return CGPointMake(seconds * (LBETimelineWidth / LBETimelineSeconds), 0);
    }
    return CGPointZero;
}

static inline CMTimeRange LBEGetTimeRangeForWidth(CGFloat width, CGFloat scaleFactor) {
    CGFloat duration = width / scaleFactor;
    return CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, NSEC_PER_SEC));
}

static inline CMTime LBEGetTimeForOrigin(CGFloat origin, CGFloat scaleFactor) {
    CGFloat seconds = origin / scaleFactor;
    return CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
}

static inline CGFloat LBEDegreesToRadians(CGFloat degrees) {
    return (degrees * M_PI / 180);
}


#endif /* LBEFunctions_h */
