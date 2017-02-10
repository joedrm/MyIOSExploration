//
//  VideoMaker.m
//  LearningAVFoundation
//
//  Created by fang wang on 17/2/10.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "VideoMaker.h"

#import "VideoMaker.h"

@implementation VideoMaker

+ (NSURL*)createVideoWithImage:(UIImage*)image {
    
    
    ///////////// setup OR function def if we move this to a separate function ////////////
    // this should be moved to its own function, that can take an imageArray, videoOutputPath, etc...
    //    - (void)exportImages:(NSMutableArray *)imageArray
    // asVideoToPath:(NSString *)videoOutputPath
    // withFrameSize:(CGSize)imageSize
    // framesPerSecond:(NSUInteger)fps {
    
    NSError *error = nil;
    
    
    // set up file manager, and file videoOutputPath, remove "test_output.mp4" if it exists...
    //NSString *videoOutputPath = @"/Users/someuser/Desktop/test_output.mp4";
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString* fileName = [NSString stringWithFormat:@"temp%04d.mp4", rand() % 10000];
    NSString *videoOutputPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    //NSLog(@"-->videoOutputPath= %@", videoOutputPath);
    // get rid of existing mp4 if exists...
    if ([fileMgr removeItemAtPath:videoOutputPath error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    
    CGSize imageSize = image.size;
    NSUInteger fps = 30;
    
    
    NSLog(@"Start building video from defined frames.");
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL: [NSURL fileURLWithPath:videoOutputPath]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:imageSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:imageSize.height], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoSettings];
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    int frameCount = 0;
    double numberOfSecondsPerFrame = 2;
    double frameDuration = fps * numberOfSecondsPerFrame;
    
    buffer = [self pixelBufferFromCGImage:[image CGImage]];
    
    BOOL append_ok = NO;
    int j = 0;
    while (!append_ok && j < 30) {
        if (adaptor.assetWriterInput.readyForMoreMediaData)  {
            //print out status:
            
            append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(0,(int32_t) fps)];
            append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frameDuration,(int32_t) fps)];
            if(!append_ok){
                NSError *error = videoWriter.error;
                if(error!=nil) {
                    NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
                }
            }
        }
        else {
            printf("adaptor not ready %d, %d\n", frameCount, j);
            [NSThread sleepForTimeInterval:0.1];
        }
        j++;
    }
    if (!append_ok) {
        printf("error appending image %d times %d\n, with error.", frameCount, j);
    }
    frameCount++;
    
    //Finish the session:
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    NSLog(@"%@", videoOutputPath);
    return [NSURL fileURLWithPath:videoOutputPath];
}

////////////////////////
+ (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CGSize size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          size.width,
                                          size.height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    if (status != kCVReturnSuccess){
        NSLog(@"Failed to create pixel buffer");
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    //kCGImageAlphaNoneSkipFirst);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end
