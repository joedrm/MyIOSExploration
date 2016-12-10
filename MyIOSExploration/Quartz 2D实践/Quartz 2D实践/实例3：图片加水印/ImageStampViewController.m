//
//  ImageStampViewController.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/10.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ImageStampViewController.h"

@interface ImageStampViewController ()

@end

@implementation ImageStampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage* image = [UIImage imageNamed:@"apple.jpg"];
    
    // 开启一个跟图片一样大小的上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    
    [image drawAtPoint:CGPointZero];
    
    NSString* str = @"hello wdy!";
    NSMutableDictionary* attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSFontAttributeName] = [UIFont systemFontOfSize:30];
    attrsDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [str drawAtPoint:CGPointMake(100, 60) withAttributes:attrsDict];
    
    // 从当前的上下文中获取一张图片
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 100, 300, 300);
    [self.view addSubview:imageView];
    imageView.image = im;
}




@end
