//
//  CustomLayerVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CustomLayerVC.h"

@interface CustomLayerVC ()
@property (nonatomic, strong) CALayer *layer;
@end

@implementation CustomLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    // 给layer设置图 .
    layer.contents = (id)[UIImage imageNamed:@"your_name"].CGImage;
    
}

// anchorPoint: 默认值是{0.5， 0.5}，position默认值是{0，0}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.layer.position = self.view.center;
    self.layer.anchorPoint = CGPointMake(0, 0);
}

@end

/* 
 
 几个概念：
 1.在iOS中，你能看得见摸得着的东西基本上都是UIView，比如一个按钮、一个文本标签、一个文本输入框、一个图标等等，这些都是UIView
 2.其实UIView之所以能显示在屏幕上，完全是因为它内部的一个图层
 3.在创建UIView对象时，UIView内部会自动创建一个图层(即CALayer对象)，通过UIView的layer属性可以访问这个层
    @property(nonatomic,readonly,retain) CALayer *layer;
 4.换句话说，UIView本身不具备显示的功能，是它内部的层才有显示功能
 
 面试题：有了UIView为什么还需要CALayer，CALayer和UIView的区别？
 首先：
    CALayer是定义在QuartzCore框架中的
    CGImageRef、CGColorRef两种数据类型是定义在CoreGraphics框架中的
    UIColor、UIImage是定义在UIKit框架中的
 其次
    QuartzCore框架和CoreGraphics框架是可以跨平台使用的，在iOS和Mac OS X上都能使用
    但是UIKit只能在iOS中使用
    为了保证可移植性，QuartzCore不能使用UIImage、UIColor，只能使用CGImageRef、CGColorRef
 
 区别：
 通过CALayer，就能做出跟UIImageView一样的界面效果
 既然CALayer和UIView都能实现相同的显示效果，那究竟该选择谁好呢？
 其实，对比CALayer，UIView多了一个事件处理的功能。也就是说，CALayer不能处理用户的触摸事件，而UIView可以
 所以，如果显示出来的东西需要跟用户进行交互的话，用UIView；如果不需要跟用户进行交互，用UIView或者CALayer都可以
 当然，CALayer的性能会高一些，因为它少了事件处理的功能，更加轻量级

*/
