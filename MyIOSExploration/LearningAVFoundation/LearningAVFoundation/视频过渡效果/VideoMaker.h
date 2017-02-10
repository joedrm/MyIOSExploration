//
//  VideoMaker.h
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/10.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface VideoMaker : NSObject

+ (NSURL*)createVideoWithImage:(UIImage*)image;

@end
