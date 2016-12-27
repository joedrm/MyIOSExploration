//
//  ViewController.m
//  Quartz 2D实践
//
//  Created by fang wang on 16/12/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 参考资料：
 http://tutuge.me/2016/12/25/TTGPuzzleVerify/  拼图验证控件TTGPuzzleVerify的实现
 */

#import "ViewController.h"

static NSString* identifier = @"cell";

@interface ViewController ()


@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) NSArray* vcArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Quartz 2D实践";
    self.titleArr = @[@"基本绘制",
                      @"绘制图片和文字",
                      @"上下文状态栈",
                      @"实例1：下载进度条",
                      @"实例2：饼状图",
                      @"实例3：图片加水印",
                      @"实例4：截屏",
                      @"实例5：图片截取",
                      @"实例6：图片擦除(撕衣服小游戏)",
                      @"实例7：手势解锁",
                      @"实例10：根据蒙版裁剪图片"];
    self.vcArr = @[@"BaseDrawViewController",
                   @"DrawImageAndTextVC",
                   @"ContextStackViewController",
                   @"ProgressViewController",
                   @"PieChartViewController",
                   @"ImageStampViewController",
                   @"ScreenshotViewController",
                   @"ImageCropViewController",
                   @"WipeImageViewController",
                   @"GestureUnlockVC",
                   @"MaskImageVC"
                   ];
}


@end
