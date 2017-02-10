//
//  VideoEditor.h
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/9.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    SimpleEditorTransitionTypeNone,
    SimpleEditorTransitionTypeCrossFade,
    SimpleEditorTransitionTypePush,
    SimpleEditorTransitionTypeCustom
} SimpleEditorTransitionType;

@interface VideoEditor : NSObject
@property (nonatomic, strong) NSArray *clips;
@property (nonatomic, strong) NSArray *clipTimeRanges;
@property (nonatomic, retain) AVURLAsset *commentary;
@property (nonatomic) CMTime commentaryStartTime;
@property (nonatomic) CMTime transitionDuration;
@property (nonatomic, retain) NSString *titleText;

@property (nonatomic) SimpleEditorTransitionType* transitionType;

- (void)buildCompositionObjectsForPlayback:(BOOL)forPlayback;
//- (void)beginExport;
- (AVAssetExportSession*)assetExportSessionWithPreset:(NSString*)presetName;
@end
