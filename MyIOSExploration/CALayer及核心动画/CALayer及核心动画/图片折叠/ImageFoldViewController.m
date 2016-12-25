//
//  ImageFoldViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ImageFoldViewController.h"

@interface ImageFoldViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ImageFoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 让上部图片只显示上半部分, 让下部图片只显示下半部分
    self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.bottomImageView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    
    self.topImageView.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bottomImageView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    // 添加渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bottomImageView.bounds;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradientLayer.opacity = 0;
    self.gradientLayer = gradientLayer;
    [self.bottomImageView.layer addSublayer:gradientLayer];
    
}

// 添加渐变层示例
- (void)gradientLayerTest{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bottomImageView.bounds;
    // 设置渐变的颜色
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor yellowColor].CGColor];
    // 设置渐变方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    // 设置渐变的位置
    gradientLayer.locations = @[@0.2, @0.6];
    [self.bottomImageView.layer addSublayer:gradientLayer];
}

- (IBAction)pan:(UIPanGestureRecognizer *)pan {
    
    // 获取移动的偏移量
    CGPoint transP = [pan translationInView:pan.view];
    // 旋转的角度
    CGFloat angle = transP.y * M_PI/ 200;
    
    // //获取一个标准默认的CATransform3D仿射变换矩阵, 近大远小
    CATransform3D transForm = CATransform3DIdentity;
    // 眼睛离屏幕的距离: 离视角近的地方放大，离视角远的地方缩小，就是所谓的视差来形成3D的效果
    
    /* CATransform3D 结构体
     struct CATransform3D
     {
     CGFloat     m11（x缩放）,m12（y切变）,m13（旋转）,m14（）;
     CGFloat     m21（x切变）,22（y缩放）,m23（）, m24（）;
     CGFloat     m31（旋转）,m32（ ）,m33（）, m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
     CGFloat     m41（x平移）,m42（y平移）, m43（z平移）,m44（）;
     };
     */
    transForm.m34 = -1 / 300.0;
    
    //设置渐变透明度
    self.gradientLayer.opacity = transP.y * 1/ 200;
    
    // 绕x轴旋转
    self.topImageView.layer.transform = CATransform3DRotate(transForm, -angle, 1, 0, 0);
    
    // 手势结束时，上部图片复位
    if (pan.state == UIGestureRecognizerStateEnded) {
        // usingSpringWithDamping： 弹性系数
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.topImageView.layer.transform = CATransform3DIdentity;
        } completion:nil];
        
    }
}


@end



