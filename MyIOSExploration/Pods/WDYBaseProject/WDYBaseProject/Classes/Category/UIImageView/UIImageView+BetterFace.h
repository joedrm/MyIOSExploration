//
//  UIImageView+BetterFace.h
//  bf
//
//  Created by croath on 13-10-22.
//  Copyright (c) 2013年 Croath. All rights reserved.
//
// https://github.com/croath/UIImageView-BetterFace
//  a UIImageView category to let the picture-cutting with faces showing better

#import <UIKit/UIKit.h>

@interface UIImageView (BetterFace)
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, assign) BOOL needsBetterFace;
@property (nonatomic, assign) BOOL fast;

void hack_uiimageview_bf();
- (void)setBetterFaceImage:(UIImage *)image;
NS_ASSUME_NONNULL_END
@end
