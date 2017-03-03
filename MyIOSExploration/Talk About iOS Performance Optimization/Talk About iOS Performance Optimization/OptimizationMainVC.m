//
//  OptimizationMainVC.m
//  Talk About iOS Performance Optimization
//
//  Created by fang wang on 17/3/3.
//  Copyright © 2017年 optimization. All rights reserved.
//

#import "OptimizationMainVC.h"

@interface OptimizationMainVC ()

@end

@implementation OptimizationMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

/*
 
 话题一：圆角图片
 参考资料：https://github.com/wazrx/XWCornerRadius  一个简单的iOS设置圆角不引起性能问题的分类
         http://www.cocoachina.com/ios/20150429/11712.html  WWDC心得与延伸:iOS图形性能
         https://github.com/liuzhiyi1992/ZYCornerRadius 一句代码，圆角风雨无阻
         https://github.com/raozhizhen/JMRoundedCorner  UIView设置不触发离屏渲染的圆角
         https://github.com/walkdianzi/DSRoundedImageArticle  iOS图片高性能设置圆角研究过程文章
         https://github.com/CoderJackyHuang/HYBImageCliped  可根据图片颜色生成图片带任意圆角，可给UIButton根据不同状态处理图片
         https://github.com/1962449521/WHUCornerMaker  优雅的给UIView及其子类加圆角和边框，无离屏，高性能，低开销，支持缓存清理和线程安全
 
 
 话题二：UIScrollView子控件重用
 参考资料：https://github.com/alibaba/LazyScrollView  天猫首页使用LazyScrollView布局，达到控件重用
 
 */
