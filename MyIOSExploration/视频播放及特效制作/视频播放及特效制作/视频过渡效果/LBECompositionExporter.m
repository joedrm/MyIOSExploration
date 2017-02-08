//
//  LBECompositionExporter.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBECompositionExporter.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LBECompositionExporter ()
@property (strong, nonatomic) id <CompositionProtocol> composition;
@property (strong, nonatomic) AVAssetExportSession *exportSession;
@end
@implementation LBECompositionExporter


- (instancetype)initWithComposition:(id <CompositionProtocol>)composition {
    
    self = [super init];
    if (self) {
        _composition = composition;
    }
    return self;
}

- (void)beginExport {
    
    self.exportSession = [self.composition makeExportable];
    self.exportSession.outputURL = [self exportURL];
    self.exportSession.outputFileType = AVFileTypeMPEG4;
    
    kWeakSelf(self)
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            kStrongSelf(self)
            AVAssetExportSessionStatus status = self.exportSession.status;
            if (status == AVAssetExportSessionStatusCompleted) {
                [self writeExportedVideoToAssetsLibrary];
                NSLog(@"Export Success!");
            } else {
                NSLog(@"Export Failed!");
            }
        });
    }];
    
    self.exporting = YES;
    [self monitorExportProgress];
}

- (void)monitorExportProgress {
    double delayInSeconds = 0.1;
    int64_t delta = (int64_t)delayInSeconds * NSEC_PER_SEC;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delta);
    
    kWeakSelf(self)
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        kStrongSelf(self)
        AVAssetExportSessionStatus status = self.exportSession.status;
        if (status == AVAssetExportSessionStatusExporting) {
            self.progress = self.exportSession.progress;
            [self monitorExportProgress];
        } else {
            self.exporting = NO;
        }
    });
}

- (void)writeExportedVideoToAssetsLibrary {
    NSURL *exportURL = self.exportSession.outputURL;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSString *message = @"Unable to write to Photos library.";
                [AlertViewHelper alertWithTitle:message message:@"Write Failed" buttonTitles:@[@"知道了"] block:^(NSInteger buttonIndex) {
                    
                }];
            }
            [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
        }];
    } else {
        NSLog(@"Video could not be exported to assets library.");
    }
}

- (NSURL *)exportURL {                                                      // 5
    NSString *filePath = nil;
    NSUInteger count = 0;
    do {
        filePath = NSTemporaryDirectory();
        NSString *numberString = count > 0 ?
        [NSString stringWithFormat:@"-%li", (unsigned long) count] : @"";
        NSString *fileNameString =
        [NSString stringWithFormat:@"Masterpiece-%@.m4v", numberString];
        filePath = [filePath stringByAppendingPathComponent:fileNameString];
        count++;
    } while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    return [NSURL fileURLWithPath:filePath];
}



@end
