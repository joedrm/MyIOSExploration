//
//  LBEBasicComposition.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompositionProtocol.h"

@interface LBEBasicComposition : NSObject<CompositionProtocol>

@property (strong, readonly, nonatomic) AVComposition *composition;

+ (instancetype)compositionWithComposition:(AVComposition *)composition;
- (instancetype)initWithComposition:(AVComposition *)composition;

@end
