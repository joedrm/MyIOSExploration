//
//  LBEVideoItem.m
//  视频播放及特效制作
//
//  Created by fang wang on 17/2/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LBEVideoItem.h"

#define THUMBNAIL_COUNT 3
#define THUMBNAIL_SIZE CGSizeMake(227.0f, 128.0f)

@interface LBEVideoItem ()
@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;
@property (strong, nonatomic) NSMutableArray *images;
@end

@implementation LBEVideoItem

+ (id)videoItemWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

- (id)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    if (self) {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
        _imageGenerator.maximumSize = THUMBNAIL_SIZE;
        _thumbnails = @[];
        _images = [NSMutableArray arrayWithCapacity:THUMBNAIL_COUNT];
    }
    return self;
}

- (CMTimeRange)playthroughTimeRange {
    CMTimeRange range = self.timeRange;
    if (self.startTransition && self.startTransition.type != LBEVideoTransitionTypeNone) {
        range.start = CMTimeAdd(range.start, self.startTransition.duration);
        range.duration = CMTimeSubtract(range.duration, self.startTransitionTimeRange.duration);
    }
    if (self.endTransition && self.endTransition.type != LBEVideoTransitionTypeNone) {
        range.duration = CMTimeSubtract(range.duration, self.endTransition.duration);
    }
    return range;
}

- (CMTimeRange)startTransitionTimeRange {
    if (self.startTransition && self.startTransition.type != LBEVideoTransitionTypeNone) {
        return CMTimeRangeMake(kCMTimeZero, self.startTransition.duration);
    }
    return CMTimeRangeMake(kCMTimeZero, kCMTimeZero);
}

- (CMTimeRange)endTransitionTimeRange {
    if (self.endTransition && self.endTransition.type != LBEVideoTransitionTypeNone) {
        CMTime beginTransitionTime = CMTimeSubtract(self.timeRange.duration, self.endTransition.duration);
        return CMTimeRangeMake(beginTransitionTime, self.endTransition.duration);
    }
    return CMTimeRangeMake(self.timeRange.duration, kCMTimeZero);
}

- (NSString *)mediaType {
    return AVMediaTypeVideo;
}

- (void)performPostPrepareActionsWithCompletionBlock:(LBEPreparationCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateThumbnailsWithCompletionBlock:completionBlock];
    });
}

- (void)generateThumbnailsWithCompletionBlock:(LBEPreparationCompletionBlock)completionBlock {
    
    CMTime duration = self.asset.duration;
    CMTimeValue intervalSeconds = duration.value / THUMBNAIL_COUNT;
    
    CMTime time = kCMTimeZero;
    NSMutableArray *times = [NSMutableArray array];
    for (NSUInteger i = 0; i < THUMBNAIL_COUNT; i++) {
        [times addObject:[NSValue valueWithCMTime:time]];
        time = CMTimeAdd(time, CMTimeMake(intervalSeconds, duration.timescale));
    }
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                              completionHandler:^(CMTime requestedTime,
                                                                  CGImageRef cgImage,
                                                                  CMTime actualTime,
                                                                  AVAssetImageGeneratorResult result,
                                                                  NSError *error)
    {
        
        if (cgImage) {
            UIImage *image = [UIImage imageWithCGImage:cgImage];
            [self.images addObject:image];
            
        } else {
            [self.images addObject:[UIImage imageNamed:@"video_thumbnail"]];
        }
        
        if (self.images.count == THUMBNAIL_COUNT) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnails = [NSArray arrayWithArray:self.images];
                completionBlock(YES);
            });
        }
    }];
}

@end
