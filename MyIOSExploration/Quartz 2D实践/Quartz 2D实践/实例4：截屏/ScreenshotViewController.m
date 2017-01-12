//
//  ScreenshotViewController.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ScreenshotViewController.h"

@interface ScreenshotViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation ScreenshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)screenShot:(UIButton *)sender {
    
    // 1. 开启一个与当前view一样大小的位图上下文
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    // 2. 把控制器的View绘制到上下文中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctx];
    
    // 3. 从上下文中生成一张图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    
    // 5. 赋值给showImageView
    self.showImageView.image = image;
}

@end
