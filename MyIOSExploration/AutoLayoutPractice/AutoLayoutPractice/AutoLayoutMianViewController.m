//
//  AutoLayoutMianViewController.m
//  AutoLayoutPractice
//
//  Created by fang wang on 17/3/6.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AutoLayoutMianViewController.h"

@interface AutoLayoutMianViewController ()

@end

@implementation AutoLayoutMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"AutoLayout 练习";
    self.titleArr = @[
                      @"Autoresizing布局",
                      @"LayoutGuide的使用"
                      ];
    
    self.vcArr = @[
                   @"AutoresizingTestViewController",
                   @"LayoutGuideTestViewController"
                   ];
}

@end


/*
 
 https://github.com/coderyi/AutoLayoutDemo
 https://github.com/johnlui/AutoLayout
 https://github.com/liaojinxing/Autolayout
 https://github.com/minggo620/iOSConstraintAnimation
 
 http://www.jianshu.com/p/0f031606e5f2
 http://www.jianshu.com/p/78316cc85044  Auto Layout学习
 http://www.jianshu.com/p/d060bef3d620  深入剖析Auto Layout，分析iOS各版本新增特性
 http://www.jianshu.com/p/212b3c0a31ab  为文章“深入剖析Auto Layout”做的slides
 
 https://blog.cnbluebox.com/blog/2015/09/18/howtolayoutview/ 如何做好IOS View的布局
 http://www.cnblogs.com/langji/p/5505803.html  关于UIView布局
 
 https://my.oschina.net/w11h22j33/blog/208574  iOS中AutoLayout自动布局流程及相关方法
 
 第三方库：
 https://github.com/netyouli/WHC_AutoLayoutKit 
 */



