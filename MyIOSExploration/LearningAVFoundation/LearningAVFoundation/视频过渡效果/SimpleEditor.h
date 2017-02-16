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

//typedef enum {
//    EditorTransitionTypeCrossFade,
//    EditorTransitionTypeCustom,
//    EditorPushHorizontalSpinFromRight,
//    EditorPushHorizontalFromRight,
//    EditorPushHorizontalFromLeft,
//    EditorPushVerticalFromBottom,
//    EditorPushVerticalFromTop,
//    EditorTransitionTypeWipe
//} EditorTransitionType;

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
@property (nonatomic) VideoTransitionType* transitionType;
@property (nonatomic, weak) id <ExportProgressDelegate> delegate;
@property (nonatomic, readonly, retain) AVMutableComposition *composition;
@property (nonatomic, readonly, retain) AVMutableVideoComposition *videoComposition;
@property (nonatomic, readonly, retain) AVMutableAudioMix *audioMix;


- (void)buildCompositionObjectsForPlayback;
- (void)addVoiceEffectsWithAudioPath:(NSString *)audioPathString;
- (AVPlayerItem *)playerItem;
- (void)exportSaveToLibrary:(BOOL)isSave exportSuccessed:(ExportSuccessBlock)block;
- (void)applyVideoEffectsWithImage:(UIImage*)image frame:(CGRect)frame;

@end
