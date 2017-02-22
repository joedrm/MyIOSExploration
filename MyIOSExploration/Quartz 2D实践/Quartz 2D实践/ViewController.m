//
//  ViewController.m
//  Quartz 2D实践
//
//  Created by fang wang on 16/12/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

/*
 参考资料：
 http://southpeak.github.io/categories/translate/page/2/  南峰子翻译的Quartz2D教程
 
 https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html Quartz 2D Programming Guide
 
 http://tutuge.me/2016/12/25/TTGPuzzleVerify/  拼图验证控件TTGPuzzleVerify的实现
 
 http://www.jianshu.com/p/24459aa51330    iOS封装一个简单的曲线图表视图
 
 https://github.com/Nyx0uf/NYXImagesKit  各种图片处理的分类，很强大
 
 http://www.swarthmore.edu/NatSci/mzucker1/opencv-2.4.10-docs/index.html  Opencv文档
 
 https://github.com/tapharmonic/QuartzDemos   很不错的Demos
 
 http://www.jianshu.com/p/e98b31051e37  基于点阵图来构建 Bezier 路径
 
 http://www.cnblogs.com/smileEvday/archive/2013/05/25/IOSImageEdit.html  Quartz2D 图像处理
 
 http://blog.csdn.net/u013282507/article/details/53121556   iOS 利用正余弦曲线实现波浪形的XLWaveProgress
 
 https://github.com/zekunyan/QuartzCodeExample-StarAimation  一个星星点赞动画
 */

#import "ViewController.h"

static NSString* identifier = @"cell";

@interface ViewController ()

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
