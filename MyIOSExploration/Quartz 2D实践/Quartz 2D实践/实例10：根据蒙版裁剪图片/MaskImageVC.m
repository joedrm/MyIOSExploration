//
//  MaskImageVC.m
//  Quartz 2D实践
//
//  Created by fang wang on 16/12/12.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 参考资料：
 
 https://github.com/AshokaCao/WaterMark 一个开源的图片处理项目，
 https://github.com/haichong/LiveAppDemo 直播 高仿映客，实现了拉流、播放、采集、滤镜、美颜
 
 */

#import "MaskImageVC.h"
#import "MaskView.h"
#import "UIImage+AlphaMask.h"

@interface MaskImageVC ()
@property (weak, nonatomic) MaskView *maskView;

@end

@implementation MaskImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"根据蒙版裁剪图片";
    
    UIImage* maskImage = [UIImage imageNamed:@"mask01.png"];
    UIImage* bgImage = [UIImage imageNamed:@"bg01.png"];
    
    CGSize screen_size = [UIScreen mainScreen].bounds.size;
    
    MaskView* maskView = [[MaskView alloc] init];
    [maskView configBgImage:maskImage maskImg:bgImage];
    maskView.backgroundColor = [UIColor redColor];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(screen_size.width - 40);
    }];
    
    
//    UIImage* image = [UIImage maskImage:bgImage withMask:maskImage];
//    self.bgImageView.image = image;
    
}


- (UIImage *)creatImageWithMaskImage:(UIImage *)maskImage andBackimage:(UIImage *)Backimage{
    
    CGRect rect;
    
    if (Backimage.size.height > Backimage.size.width) {
        rect = CGRectMake(0, (Backimage.size.height-Backimage.size.width), Backimage.size.width*2, Backimage.size.width*2);
    }else{
        rect = CGRectMake((Backimage.size.width-Backimage.size.height),0,Backimage.size.height*2, Backimage.size.height*2);
    }
    
    NSLog(@"%f",(Backimage.size.height - Backimage.size.height)/2);
    
    UIImage *cutIMG = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([Backimage CGImage], rect)];
    
    //遮罩图
    CGImageRef maskImageRef = maskImage.CGImage;
    //原图
    CGImageRef originImageRef = cutIMG.CGImage;
    
    
    
    static const size_t kComponentsPerPixel = 4;
    static const size_t kBitsPerComponent = sizeof(unsigned char) * 8;
    
    NSInteger layerHeight = 160;
    NSInteger layerWidth = 160;
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    size_t bufferLength = layerWidth * layerHeight * kComponentsPerPixel;
    
    unsigned char *buffer = malloc(bufferLength);
    
    for (NSInteger i = 0; i < bufferLength; ++i)
    {
        buffer[i] = 255;
    }
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(maskImageRef);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, &buffer, bufferLength, NULL);
    
    CGImageRef imageRef = CGImageCreate(rect.size.width, rect.size.height, kBitsPerComponent, kBitsPerComponent * kComponentsPerPixel, kComponentsPerPixel * layerWidth, rgb, bitmapInfo, provider, NULL, false, kCGRenderingIntentDefault);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate (NULL, rect.size.width, rect.size.height, 8, 0, colorSpace,  kCGImageAlphaPremultipliedLast);
    
    CGImageRef image = CGImageCreateWithMask(originImageRef, imageRef);
    
//    CGContextClipToMask(ctx,CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskImageRef);
//    CGContextDrawImage(ctx, CGRectMake(0,0, rect.size.width, rect.size.height), image);
//    CGContextClearRect(ctx, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height));
//    CGContextFillRect(ctx, rect);
    
    // 从一个位图图形上下文创建一个图像
    CGImageRef bitmapContext = CGBitmapContextCreateImage(ctx);
    UIImage *theImage = [UIImage imageWithCGImage:image];
    
    // 释放资源
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(ctx);
    CGImageRelease(bitmapContext);
    
    return theImage;
}


@end
