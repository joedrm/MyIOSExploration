//
//  UIImageView+ImageFitSize.m
//  MultiCustomUIComponent
//
//  Created by wdy on 2017/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "UIImageView+ImageFitSize.h"
#import "CommonDefines.h"

@implementation UIImageView (ImageFitSize)
- (void)sizeToFitKeepingImageAspectRatioInSize:(CGSize)limitSize {
    if (!self.image) {
        return;
    }
    CGSize currentSize = self.frame.size;
    if (currentSize.width <= 0) {
        currentSize.width = self.image.size.width;
    }
    if (currentSize.height <= 0) {
        currentSize.height = self.image.size.height;
    }
    CGFloat horizontalRatio = limitSize.width / currentSize.width;
    CGFloat verticalRatio = limitSize.height / currentSize.height;
    CGFloat ratio = fminf(horizontalRatio, verticalRatio);
    CGRect frame = self.frame;
    frame.size.width = flatf(currentSize.width * ratio);
    frame.size.height = flatf(currentSize.height * ratio);
    self.frame = frame;
}
@end
