//
//  VisualEffectVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2016/12/29.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "VisualEffectVC.h"

@interface VisualEffectVC ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation VisualEffectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 1. 圆角: conrnerRadius的属性控制着图层角的曲率
    
    // 2. 图层边框:
    // borderWidth是以点为单位的定义边框粗细的浮点数，默认为0.borderColor定义了边框的颜色，默认为黑色。
    // borderColor是CGColorRef类型，而不是UIColor，所以它不是Cocoa的内置对象。
    
    // 3. 阴影
    // shadowOpacity透明度,shadowColor属性控制着阴影的颜色,shadowOffset属性控制着阴影的方向和距离,
    
    
    // 4. 阴影裁剪: 阴影通常就是在Layer的边界之外，如果你开启了masksToBounds属性，所有从图层中突出来的内容都会被才剪掉。
    
    // 5. shadowPath属性
    // shadowPath是一个CGPathRef类型（一个指向CGPath的指针）。CGPath是一个Core Graphics对象，用来指定任意的一个矢量图形。
    self.redView.layer.contents = (__bridge id _Nullable)kImage(@"test.jpg").CGImage;
    self.redView.layer.shadowOpacity = 0.5f;
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.redView.bounds);
    self.redView.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
    
    self.greenView.layer.contents = (__bridge id _Nullable)kImage(@"test.jpg").CGImage;
    self.greenView.layer.shadowOpacity = 0.5f;
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.greenView.bounds);
    self.greenView.layer.shadowPath = circlePath;
    CGPathRelease(circlePath);
    
    
    // 6. mask 图层蒙板
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = self.imageView.bounds;
    UIImage* maskImage = kImage(@"");
    maskLayer.contents = (__bridge id _Nullable)(maskImage.CGImage);
    // 给ImageView设置蒙版
    self.imageView.layer.mask = maskLayer;
    
    // 7. 拉伸过滤，minificationFilter和magnificationFilter属性, 三种拉伸过滤方法，他们是：
    /*
    kCAFilterLinear: minification（缩小图片）和magnification（放大图片）默认的过滤器都是kCAFilterLinear, 采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。
     
    kCAFilterNearest: kCAFilterNearest是一种比较武断的方法。从名字不难看出，这个算法（也叫最近过滤）就是取样最近的单像素点而不管其他的颜色。这样做非常快，也不会使图片模糊。但是，最明显的效果就是，会使得压缩图片更糟，图片放大之后也显得块状或是马赛克严重。
     
    kCAFilterTrilinear: kCAFilterTrilinear和kCAFilterLinear非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而�得到最后的结果。
     */
    
    
    
    // 8. 组透明: shouldRasterize属性
    // UIView有一个叫做alpha的属性来确定视图的透明度。CALayer有一个等同的属性叫做opacity，这两个属性都是影响子层级的。也就是说，如果你给一个图层设置了opacity属性，那它的子图层都会受此影响
    // 按钮和文本框都是白色背景。虽然他们都是50%的可见度，但是合起来的可见度是75%，所以标签所在的区域看上去就没有周围的部分那么透明。所以看上去子视图就高亮了，使得这个显示效果都糟透了。理想状况下，当你设置了一个图层的透明度，你希望它包含的整个图层树像一个整体一样的透明效果。你可以通过设置Info.plist文件中的UIViewGroupOpacity为YES来达到这个效果，但是这个设置会影响到这个应用，整个app可能会受到不良影响。
    // 另一个方法就是，你可以设置CALayer的一个叫做shouldRasterize属性来实现组透明的效果，如果它被设置为YES，在应用透明度之前，图层及其子图层都会被整合成一个整体的图片，这样就没有透明度混合的问题了
    // 为了启用shouldRasterize属性，我们设置了图层的rasterizationScale属性。默认情况下，所有图层拉伸都是1.0， 所以如果你使用了shouldRasterize属性，你就要确保你设置了rasterizationScale属性去匹配屏幕，以防止出现Retina屏幕像素化的问题。
    self.button.layer.opacity = 0.5;
    self.button.layer.shouldRasterize = YES;
    self.button.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}



@end
