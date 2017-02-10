//
//  LBETimelineBuilder.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBETimeline.h"

@interface LBETimelineBuilder : NSObject
+ (LBETimeline *)buildTimelineWithMediaItems:(NSArray *)mediaItems transitionsEnabled:(BOOL)enabled;
@end
