//
//  LBEAudioItem.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEAudioItem.h"

@implementation LBEAudioItem

+ (id)audioItemWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

- (NSString *)mediaType {
    return AVMediaTypeAudio;
}

@end
