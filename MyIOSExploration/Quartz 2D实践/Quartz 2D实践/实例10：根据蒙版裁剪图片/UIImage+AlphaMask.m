//
//  UIImage+AlphaMask.m
//  Quartz 2D实践
//
//  Created by fang wang on 16/12/12.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "UIImage+AlphaMask.h"

@implementation UIImage (AlphaMask)

+(UIImage*)maskImage:(UIImage*)originImage toPath:(UIBezierPath*)path{
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    [path addClip];
    [originImage drawAtPoint:CGPointZero];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
}

//这段代码的思想是：通过获取图片在内存中的二进制存储的数组，定点到对应的rgb数据。
//中心方法是CGBitmapContextGetData函数，通过一个context获取context中图片的数组。
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow  = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount    = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease( colorSpace );
    return context;
}

// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage)
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    //使用上面的函数创建上下文
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    
    CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    CGContextRelease(cgctx);
    return data;
}

- (UIImage *) changColorOfImage:(UIImage*)inImage withColor:(UIColor *)color{
    CGImageRef inImageRef = [inImage CGImage];
    float w = CGImageGetWidth(inImageRef);
    float h = CGImageGetHeight(inImageRef);
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h), inImageRef);
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSourceIn);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    
    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
    //this however has a computational cost
    
    if (CGImageGetAlphaInfo(sourceImage) == 5) {
        NSLog(@"%u",CGImageGetAlphaInfo(maskRef));
        imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
    }
    
//    if (CGImageGetAlphaInfo(mask) == 0) {
//        NSLog(@"%u",CGImageGetAlphaInfo(maskRef));
//        mask = CopyImageAndAddAlphaChannel(mask);
//    }

    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
//    release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;
}


+ (UIImage*) mask2Image:(UIImage *)image withMask:(UIImage *)maskImage {
    
    /*
     CGImageRef maskRef = maskImage.CGImage;
     
     CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
     CGImageGetHeight(maskRef),
     CGImageGetBitsPerComponent(maskRef),
     CGImageGetBitsPerPixel(maskRef),
     CGImageGetBytesPerRow(maskRef),
     CGImageGetDataProvider(maskRef), NULL, false);
     
     CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
     UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
     
     CGImageRelease(mask);
     CGImageRelease(maskedImageRef);
     
     // returns new image with mask applied
     return maskedImage;
     */
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width/ image.size.width;
    
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image.size.height;
    }
    
    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
    
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    // return the image
    return theImage;
    
}


+ (UIImage*) mask3Image:(UIImage *)image withMask:(UIImage *)maskImage
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSaveGState(context);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, rect, maskImage.CGImage);
    CGContextRestoreGState(context);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    theImage = [UIImage imageWithCGImage:theImage.CGImage scale:2 orientation:theImage.imageOrientation];
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)mask4Image:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef bgImageRef = image.CGImage;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    /*
     size_t width, //图片的宽度
     size_t height, //图片的高度
     size_t bitsPerComponent,  //图片每个颜色的bits，比如rgb颜色空间，有可能是5 或者 8 ==
     size_t bitsPerPixel,  //每一个像素占用的buts，15 位24位 32位等等
     size_t bytesPerRow, //每一行占用多少bytes 注意是bytes不是bits  1byte ＝ 8bit
     CGColorSpaceRef colorspace,  //颜色空间，比如rgb
     CGBitmapInfo bitmapInfo,  //layout ，像素中bit的布局， 是rgba还是 argb，＝＝
     CGDataProviderRef provider,  //数据源提供者，url或者内存＝＝
     const CGFloat decode[],  //一个解码数组
     bool shouldInterpolate,  //抗锯齿参数
     CGColorRenderingIntent intent //图片渲染相关参数
     */
    CGImageRef mask = CGImageCreate(CGImageGetWidth(maskRef),
                                    CGImageGetHeight(maskRef),
                                    CGImageGetBitsPerComponent(maskRef),
                                    CGImageGetBitsPerPixel(maskRef),
                                    CGImageGetBytesPerRow(maskRef),
                                    CGColorSpaceCreateDeviceRGB(),
                                    kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault,
                                    CGImageGetDataProvider(maskRef),
                                    NULL,
                                    false,
                                    kCGRenderingIntentDefault);

    NSLog(@"%zu, %zu, %zu, %@", CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef));
    NSLog(@"mask = %@", mask);
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
//                                        CGImageGetHeight(maskRef),
//                                        CGImageGetBitsPerComponent(maskRef),
//                                        CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef),
//                                        CGImageGetDataProvider(maskRef), NULL, true);
    
    CGImageRef masked = CGImageCreateWithMask(bgImageRef, mask);
    
    return [UIImage imageWithCGImage:masked];
}

//  baseImage 要截取的图片； theMaskImage 遮罩层图片
+ (UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage
{
    CGImageRetain(baseImage.CGImage);
    CGImageRetain(theMaskImage.CGImage);
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGImageRef maskRef = theMaskImage.CGImage;
    
    CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                             CGImageGetHeight(maskRef),
                                             CGImageGetBitsPerComponent(maskRef),
                                             CGImageGetBitsPerPixel(maskRef),
                                             CGImageGetBytesPerRow(maskRef),
                                             CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([baseImage CGImage], maskImage);
    CGImageRelease(maskImage);
    CGImageRelease(maskRef);
    
    CGContextDrawImage(ctx, area, masked);
    CGImageRelease(masked);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/* 简介：王建林（Apathy） 用来遮罩图片成需要的形状 */
+ (UIImage*) mask5Image:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = [maskImage CGImage];
    
    // 获取遮罩层
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef)
                                              ,CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef),
                                              NULL,
                                              false);
    // 合成图片
    CGImageRef sourceImageRef = CGImageCreateWithMask(image.CGImage, actualMask);
    
    return [UIImage imageWithCGImage:sourceImageRef];
    
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparentWithColor:(UIColor *)color{
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    red *= 255;
    green *= 255;
    blue *= 255;
    
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


@end
