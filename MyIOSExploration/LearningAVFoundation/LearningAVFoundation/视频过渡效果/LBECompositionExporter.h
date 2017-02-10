//
//  LBECompositionExporter.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBETimeline.h"
#import "CompositionProtocol.h"

@interface LBECompositionExporter : NSObject
@property (nonatomic) BOOL exporting;
@property (nonatomic) CGFloat progress;
- (instancetype)initWithComposition:(id <CompositionProtocol>)composition;
- (void)beginExport;
@end
