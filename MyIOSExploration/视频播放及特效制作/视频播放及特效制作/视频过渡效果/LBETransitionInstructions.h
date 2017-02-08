//
//  LBETransitionInstructions.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBEVideoTransition.h"

@interface LBETransitionInstructions : NSObject
@property (strong, nonatomic) AVMutableVideoCompositionInstruction *compositionInstruction;
@property (strong, nonatomic) AVMutableVideoCompositionLayerInstruction *fromLayerInstruction;
@property (strong, nonatomic) AVMutableVideoCompositionLayerInstruction *toLayerInstruction;
@property (strong, nonatomic) LBEVideoTransition *transition;
@end
