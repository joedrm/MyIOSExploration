//
//  UIImageView+ImageFitSize.h
//  MultiCustomUIComponent
//
//  Created by wdy on 2017/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageFitSize)
- (void)sizeToFitKeepingImageAspectRatioInSize:(CGSize)limitSize;
@end
