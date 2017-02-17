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
#import "VideoEffectTheme.h"

typedef enum {
    VideoTransitionTypeFadeIn = 0,
    VideoTransitionTypeFadeOut,
    VideoTransitionTypeDisolve,
    VideoTransitionTypePush,
    VideoTransitionTypePushFromTop,
    VideoTransitionTypePushFromBottom,
    VideoTransitionTypePushFromLeft,
    VideoTransitionTypePushFromRight,
    VideoTransitionTypeZoomIn,
    VideoTransitionTypeWipe
} VideoTransitionType;

@protocol ExportProgressDelegate <NSObject>

- (void)exportVideoProgress:(float)progress;

@end

typedef void(^ExportSuccessBlock)(NSString* exportPathStr, BOOL isExportSuccessed);

@interface SimpleEditor : NSObject

@property (nonatomic, copy) NSArray *clips;
@property (nonatomic, copy) NSArray *clipTimeRanges;
@property (nonatomic) CMTime transitionDuration;
@property (nonatomic) VideoTransitionType* transitionType; //转场动画效果
@property (assign, nonatomic) ThemesType themeCurrentType; //主题类型
@property (nonatomic, weak) id <ExportProgressDelegate> delegate;
@property (nonatomic, readonly, retain) AVMutableComposition *composition;
@property (nonatomic, readonly, retain) AVMutableVideoComposition *videoComposition;
@property (nonatomic, readonly, retain) AVMutableAudioMix *audioMix;


- (void)buildCompositionObjectsForPlayback;
- (void)applyVideoEffects;
- (AVPlayerItem *)playerItem;
- (void)exportSaveToLibrary:(BOOL)isSave exportSuccessed:(ExportSuccessBlock)block;

@end
