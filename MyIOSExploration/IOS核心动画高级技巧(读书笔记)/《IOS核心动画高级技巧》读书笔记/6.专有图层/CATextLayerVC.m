//
//  CATextLayerVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/1.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CATextLayerVC.h"
#import <CoreText/CoreText.h>
#import "LayerLabel.h"

@interface CATextLayerVC ()

@end

@implementation CATextLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
    [self test4];
    [self test5];
}

#pragma mark - 3.CATextLayer
/*
 CATextLayer也要比UILabel渲染得快得多。很少有人知道在iOS 6及之前的版本，UILabel其实是通过WebKit来实现绘制的，这样就造成了当有很多文字的时候就会有极大的性能压力。而CATextLayer使用了Core text，并且渲染得非常快。
 */
- (void)test3{
    
    CATextLayer* textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.frame = CGRectMake(200, kStatusBarAndNavigationBarHeight, self.view.width - 220, self.view.width - 220 - 20);
    [self.view.layer addSublayer:textLayer];
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = kFontWithSize(14);
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    NSString* text = @"do up or shut up!";
    textLayer.string = text;
    // 解决像素化问题
    textLayer.contentsScale = [UIScreen mainScreen].scale;
}

#pragma mark - 4.富文本
- (void)test4{
    
    CATextLayer* textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.frame = CGRectMake(10, kStatusBarAndNavigationBarHeight + self.view.width - 220, kScreenWidth - 20, self.view.width - 220);
    
    [self.view.layer addSublayer:textLayer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    NSString* text = KTextString;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString* string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFloat fontSize = font.pointSize;
    
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    NSDictionary* attrs = @{
                            (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor blackColor].CGColor,
                            (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                            };
    
    [string setAttributes:attrs range:NSMakeRange(0, text.length)];
    
    
    attrs = @{
              (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
              (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
              };
    
    [string setAttributes:attrs range:NSMakeRange(6, 5)];
    
    CFRelease(fontRef);
    
    textLayer.string = string;
}


#pragma mark - UILabel的替代品
- (void)test5{
    
    LayerLabel* label = [[LayerLabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth-20, 200)];
    label.backgroundColor = [UIColor blackColor];
    label.center = self.view.center;
    label.y = self.view.centerY + 100;
    label.text = KTextString;
    label.textColor = [UIColor whiteColor];
    label.font = kFontWithSize(12);
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
