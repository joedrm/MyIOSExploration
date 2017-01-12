//
//  WipeImageViewController.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/11.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "WipeImageViewController.h"

@interface WipeImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *preImageView;
@property (weak, nonatomic) IBOutlet UIImageView *afterImageView;

@end

@implementation WipeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preImageView.userInteractionEnabled = YES;
    // 添加手势
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wipeAction:)];
    [self.preImageView addGestureRecognizer:pan];
}

- (void)wipeAction:(UIGestureRecognizer*)pan{
    
    // 获取当前手指的点
    CGPoint curP = [pan locationInView:self.preImageView];
    // 确定擦除区域
    CGFloat rectWH = 30;
    CGFloat x = curP.x - rectWH *0.5;
    CGFloat y = curP.y - rectWH *0.5;
    CGRect rect = CGRectMake(x, y, rectWH, rectWH);
    
    // 生成一张带有透明擦除区域的图片
    
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.preImageView.bounds.size, NO, 0);
    // 把UIImage渲染到当前上下文中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.preImageView.layer renderInContext:ctx];
    
    CGContextClearRect(ctx, rect);
    
    // 从上下文中取出图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.preImageView.image = newImage;
}


@end
