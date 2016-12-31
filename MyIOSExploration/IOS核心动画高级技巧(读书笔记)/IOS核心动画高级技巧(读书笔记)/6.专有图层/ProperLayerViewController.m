//
//  ProperLayerViewController.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ProperLayerViewController.h"

@interface ProperLayerViewController ()

@end

@implementation ProperLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testShapeLayer];
    [self test2];
    [self test3];
}

#pragma mark - CAShapeLayer
// CAShapeLayer 与 使用Core Graphics直接向原始的CALyer绘制 的区别：
/*
 渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
 高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
 不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 */
- (void)testShapeLayer{

    UIBezierPath* path = [UIBezierPath bezierPath];
    // 画圆
    [path addArcWithCenter:CGPointMake(175, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [path moveToPoint:CGPointMake(175, 125)];
    [path addLineToPoint:CGPointMake(175, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    
    [path moveToPoint:CGPointMake(175, 175)];
    [path addLineToPoint:CGPointMake(225, 225)];
    
    [path moveToPoint:CGPointMake(125, 150)];
    [path addLineToPoint:CGPointMake(225, 150)];
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
}


#pragma mark - 2.圆角
- (void)test2{
    
    CGRect rect = CGRectMake(50, 300, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner coner = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:coner cornerRadii:radii];
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
}

#pragma mark - 3.CATextLayer
/*
 CATextLayer也要比UILabel渲染得快得多。很少有人知道在iOS 6及之前的版本，UILabel其实是通过WebKit来实现绘制的，这样就造成了当有很多文字的时候就会有极大的性能压力。而CATextLayer使用了Core text，并且渲染得非常快。
 */
- (void)test3{

    CATextLayer* textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    textLayer.frame = CGRectMake(200, 300, self.view.width - 220, self.view.width - 220);
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

    
}
@end
























