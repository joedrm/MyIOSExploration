//
//  MaskView.m
//  Quartz 2D实践
//
//  Created by fang wang on 16/12/12.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "MaskView.h"
#import "ImageUtil.h"
#import <OpenGLES/EAGL.h>
//#import "GLESUtils.h"
//#import "GLESMath.h"

@interface MaskView ()
{
    UIImage* _bgImage;
    UIImage* _maskImage;
}
@end

@implementation MaskView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configBgImage:(UIImage *)bgImage maskImg:(UIImage *)maskImage{
    _bgImage = bgImage;
    _maskImage = maskImage;
    
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0.0, rect.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGImageRef maskRef = _maskImage.CGImage;
    CGImageRef bgImageRef = _bgImage.CGImage;
    
//    UIImage* newImage = [ImageUtil imageWithImage:_maskImage withColorMatrix:colormatrix_heibai];
    
    CGContextDrawImage(ctx, rect, maskRef);
    CGContextDrawImage(ctx, rect, bgImageRef);
    
    UIImage* newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"%@",newImg);
    
//    CGContextClearRect(ctx, CGRectMake(100, 0, _maskImage.size.width, _maskImage.size.height));
    
    
    
    
//    UIImage* resultImg = [ImageUtil imageWithImage:image withColorMatrix:000];
//    
//    CGContextDrawImage(ctx, rect, resultImg.CGImage);
    
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
//    CGImageRef mask = CGImageCreate(CGImageGetWidth(maskRef),
//                                    CGImageGetHeight(maskRef),
//                                    CGImageGetBitsPerComponent(maskRef),
//                                    CGImageGetBitsPerPixel(maskRef),
//                                    CGImageGetBytesPerRow(maskRef),
//                                    CGColorSpaceCreateDeviceRGB(),
//                                    bitmapInfo,
//                                    CGImageGetDataProvider(maskRef),
//                                    NULL,
//                                    false,
//                                    renderingIntent);
    
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//                                        CGImageGetHeight(maskRef),
//                                        CGImageGetBitsPerComponent(maskRef),
//                                        CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef),
//                                        CGImageGetDataProvider(maskRef), NULL, true);
    

//    CGImageRef masked = CGImageCreateWithMask(bgImageRef, mask);
//    CGContextDrawImage(ctx, rect, masked);
//    [newImage drawInRect:rect blendMode:kCGBlendModeMultiply alpha:1.0];
    
    CGContextStrokePath(ctx);
}

@end




