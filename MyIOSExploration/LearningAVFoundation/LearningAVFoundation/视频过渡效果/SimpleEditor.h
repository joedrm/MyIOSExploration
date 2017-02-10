//
//  SimpleEditor.h
//  LearnAVFoundation
//
//  Created by 林伟池 on 16/6/28.
//  Copyright © 2016年 林伟池. All rights reserved.
//

// http://www.jianshu.com/p/3c585899c455

#import <Foundation/Foundation.h>
#import <CoreMedia/CMTime.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    EditorTransitionTypeNone,
    EditorTransitionTypeCrossFade,
    EditorTransitionTypePush,
    EditorTransitionTypeCustom
} EditorTransitionType;

@interface SimpleEditor : NSObject

@property (nonatomic, copy) NSArray *clips;
@property (nonatomic, copy) NSArray *clipTimeRanges;
@property (nonatomic) CMTime transitionDuration;
@property (nonatomic) EditorTransitionType* transitionType;

@property (nonatomic, readonly, retain) AVMutableComposition *composition;
@property (nonatomic, readonly, retain) AVMutableVideoComposition *videoComposition;
@property (nonatomic, readonly, retain) AVMutableAudioMix *audioMix;

- (void)buildCompositionObjectsForPlayback;
- (AVPlayerItem *)playerItem;
- (void)beginExport;
@end
