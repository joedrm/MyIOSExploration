//
//  BoardViewLayerVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2016/12/28.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "BoardViewLayerVC.h"

@interface BoardViewLayerVC ()
@property (nonatomic, strong) UIView *layerView;
@end

@implementation BoardViewLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView* layerView = [[UIView alloc] init];
    layerView.backgroundColor = [UIColor whiteColor];
    layerView.frame = CGRectMake(0, 0, 200, 300);
    layerView.center = self.view.center;
    [self.view addSubview:layerView];
    self.layerView = layerView;
    
    // 1. contents 属性
    // contents这个奇怪的表现是由Mac OS的历史原因造成的。它之所以被定义为id类型，是因为在Mac OS系统上，这个属性对CGImage和NSImage类型的值都起作用。
    UIImage* image = [UIImage imageNamed:@"test.jpg"];
    self.layerView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    // 2. contentGravity 属性
    // CALayer与UIView的contentMode对应的属性叫做contentsGravity，目的是为了决定内容在图层的边界中怎么对齐
    /*
     kCAGravityCenter
     kCAGravityTop
     kCAGravityBottom
     kCAGravityLeft
     kCAGravityRight
     kCAGravityTopLeft
     kCAGravityTopRight
     kCAGravityBottomLeft
     kCAGravityBottomRight
     kCAGravityResize
     kCAGravityResizeAspect
     kCAGravityResizeAspectFill
     */
    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
    
    // 3. contentsScale 属性
    // contentsScale属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数
    // 和UIImage不同，CGImage没有拉伸的概念。当我们使用UIImage类去读取图片的时候，它读取了高质量的Retina版本的图片。但是当我们用CGImage来设置我们的图层的内容时，拉伸这个因素在转换的时候就丢失了。不过我们可以通过手动设置contentsScale
    self.layerView.layer.contentsScale = image.scale;
    //layer.contentsScale = [UIScreen mainScreen].scale;
    
    // 4. masksToBounds
    // 裁剪超出边界的图片
    self.layerView.layer.masksToBounds = YES;
    
    
    // 5. contentsRect 属性
    // 和bounds，frame不同，contentsRect不是按点来计算的，它使用了单位坐标，单位坐标指定在0到1之间，是一个相对值（像素和点就是绝对值）。所以它们是相对与寄宿图的尺寸的, 默认的contentsRect是{0, 0, 1, 1}，这意味着整个寄宿图默认都是可见的，如果我们指定一个小一点的矩形，图片就会被裁剪，常被用于图片拼合
    UIView* topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:topView];
    
    UIView* bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, self.view.frame.size.height - 100, 100, 100);
    [self.view addSubview:bottomView];
    
    [self addSpriteImage:image withContentRect:CGRectMake(0, 0, 1, 0.5) toLayer:topView.layer];
    [self addSpriteImage:image withContentRect:CGRectMake(0, 0.5, 1, 0.5) toLayer:bottomView.layer];
    
    // 6. contentsCenter 属性
    // contentsCenter其实是一个CGRect，它定义了一个固定的边框和一个在图层上可拉伸的区域。 改变contentsCenter的值并不会影响到寄宿图的显示，除非这个图层的大小改变了，你才看得到效果，默认情况下，contentsCenter是{0, 0, 1, 1}，这意味着如果大小（由conttensGravity决定）改变了,那么寄宿图将会均匀地拉伸开, 工作起来的效果和UIImage里的-resizableImageWithCapInsets: 方法效果非常类似
    UIButton* btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.frame = CGRectMake(self.view.frame.size.width - 100, 80, 100, 100);
    [self.view addSubview:btn];
    [self addStretchableImage:image withContentCenter:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:btn.layer];
    
    
    // 7. 
}

// contentsRect: 图片合并或拆分
- (void)addSpriteImage:(UIImage*)image withContentRect:(CGRect)rect toLayer:(CALayer*)layer
{
    layer.contents = (__bridge id _Nullable)(image.CGImage);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contentsRect = rect;
}

// contentsCenter:
- (void)addStretchableImage:(UIImage *)image withContentCenter:(CGRect)rect toLayer:(CALayer *)layer
{
    layer.contents = (__bridge id _Nullable)(image.CGImage);
    layer.contentsCenter = rect;
}

@end














