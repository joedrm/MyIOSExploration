//
//  ImageCropViewController.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ImageCropViewController.h"

@interface ImageCropViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (assign, nonatomic) CGPoint startP;
@property (strong, nonatomic) UIView* coverView;
@end

@implementation ImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageV.userInteractionEnabled = YES;
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
    // 判断手势的状态
    CGPoint curP = [sender locationInView:self.imageV];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startP = curP;
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
        CGFloat x = self.startP.x;
        CGFloat y = self.startP.y;
        CGFloat w = curP.x - self.startP.x;
        CGFloat h = curP.y - self.startP.y;
        CGRect rect = CGRectMake(x, y, w, h);
        
        self.coverView.frame = rect;
    }else if (sender.state == UIGestureRecognizerStateEnded){
        // 把超出cover的frame以外的裁剪掉
        // 生成一张图片。把原来的图片替换掉
        
        UIGraphicsBeginImageContextWithOptions(self.imageV.bounds.size, NO, 0);
        
        // 把imageV绘制到上下文之前，设置一个裁剪区域
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.coverView.frame];
        [path addClip];
        
        // 把当前的imageView渲染到上下文中
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageV.layer renderInContext:ctx];
        
        // 从上下文生成一张图片
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭上下文
        UIGraphicsEndImageContext();
        
        // 移除遮盖
        [self.coverView removeFromSuperview];
        
        self.imageV.image = newImage;
    }
}

- (UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.7;
        [self.view addSubview:_coverView];
    }
    return _coverView;
}

@end
