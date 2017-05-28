//
//  ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

/*
 参考地址：
 
 http://tutuge.me/tags/Autolayout/
 https://github.com/johnlui/AutoLayout
 https://github.com/zekunyan/AutolayoutExampleWithMasonry  已读
 https://github.com/CoderJackyHuang/MasonryDemo
 https://github.com/HApple/AutoLayout
 https://github.com/HqRaining78/Masonry-demo-collection
 https://github.com/adad184/DemoMasonry   已读
 https://github.com/adad184/DemoMasonryPlus  先读
 https://github.com/adad184/DemoScrollViewAutolayout
 
 http://www.cnblogs.com/-ljj/p/4470658.html
 
 http://blog.csdn.net/linwenbang/article/details/49124195 Masonry的使用，动画，出现问题解决等
 
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Masonry实践";
    self.titleArr = @[
                      @"Case1: 并排两个label，宽度由内容决定。父级View宽度不够时，优先显示左边label的内容",
                      @"Case2: 四个ImageView整体居中，可以任意显示、隐藏",
                      @"Case3: 子View的宽度始终是父级View的一半（或者任意百分比）",
                      @"Case4: 动态计算cell高度",
                      @"Case5: Header头部拉伸效果",
                      @"Case6: Cell的展开和收缩",
                      @"Case7: 两种方式实现等间距",
                      @"Case8: 约束动画",
                      @"ScrollView的竖向布局",
                      @"ScrollView的横向布局",
                      @"Case9: 横向或纵向实现多个View等间距",
                      @"case10: 数组排列",
                      @"Case11: 优先级",
                      @"Case12: 自定义View更新布局",
                      @"Case13: UITableViewCell中多个变高的Label",
                      @"Case14: 自定义View实现intrinsicContentSize",
                      @"Case15: 给同一个属性添加多重约束，实现复杂关系"];
    
    self.vcArr = @[
                   @"Case1ViewController",
                   @"Case2ViewController",
                   @"Case3ViewController",
                   @"Case4ViewController",
                   @"Case5ViewController",
                   @"Case6ViewController",
                   @"Case7ViewController",
                   @"Case8ViewController",
                   @"ScrollViewController",
                   @"HorizontalScrollViewController",
                   @"Case9ViewController",
                   @"ArrayButtonLayoutVC",
                   @"Case11ViewController",
                   @"Case12ViewController",
                   @"Case13ViewController",
                   @"Case14ViewController",
                   @"Case15ViewController"
                   ];
}


@end


