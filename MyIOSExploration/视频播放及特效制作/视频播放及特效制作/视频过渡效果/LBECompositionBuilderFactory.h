//
//  LBECompositionBuilderFactory.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBETimeline.h"
#import "CompositionBuilderProtocol.h"

@interface LBECompositionBuilderFactory : NSObject

- (id <CompositionBuilderProtocol>)builderForTimeline:(LBETimeline *)timeline;

@end
