//
//  ViewController.m
//  translucent属性设置的问题
//
//  Created by wdy on 2016/10/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "TransTestViewController.h"
#import "DeafultViewController.h"
#import "TransDemo1VC.h"
#import "TransDemo2VC.h"
#import "TransDemo3VC.h"
#import "TransDemo4VC.h"

@interface TransTestViewController ()

@end

@implementation TransTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
 使用UINavigationController和UITabBarController，而且不修改其中的translucent等属性，在页面中添加tableView，
 设置tableview距离四面【0，0，0，0】并设置tableview的背景色为red.可以发现界面的上bar覆盖的红色能模糊看到，是半透明效果。
 但是我们还是可以正常看到第一个(上下滑动），不会被半透明遮挡。
 
     (1): 对于滚动视图，系统默认viewControllerautomaticallyAdjustsScrollViewInsets属性为YES，所以默认会做下面这件事
         本来我们的cell是放在（0,0）的位置上的，但是考虑到导航栏、状态栏会挡住后面的主视图，而自动把我们的内容（cell、滚动视图里的元素）
         向下偏移离Top64px（下方位置果是tarbar向上偏移离Buttom49px、toolbar是44），也就是当我们把navigationBar给隐藏掉时，
         滚动视图会给我们的内容预留部分的空白Top（所有内容向下偏移20px，因为状态栏的存在）。
     
     (2): 但是对于非滚动视图是没有这种特殊性的
         在tableview上方加一块青绿色的UILabel“紧贴着”tableview（也就是设置四边【0，0，0，0】），并且我们还是使用的默认的这一属性：
         self.automaticallyAdjustsScrollViewInsets = YES;
         对于非滚动视图并没有这样的特殊性，顶部的内容会被bar遮挡掉。但是在半透明（translucent属性为YES）的前提下，
         automaticallyAdjustsScrollViewInsets属性还是为YES的时候，滚动视图还是会自动空出64px的位置，也就是我们看到的红色背景。

 需求一：对于非滚动视图，我想让它从（0，0）布局，但是又正常显示，不会被遮挡该怎么做呢？
        需要分两种效果：是否需要半透明的效果
        效果一：需要半透明，就是说tabBar和navigationBar的translucnet还是默认的YES时
            方法1：你可以不从（0，0）开始布局，而是从（0，64）开始布局（同理，底部的tabBar也要留下位置）
            方法2：你一定要从（0，0）开始布局，则修改viewController的一个属性：
                //iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方。
                self.edgesForExtendedLayout = UIRectEdgeNone;
        此效果实现在 TransDemo1VC中
 
 参考资料：http://blog.csdn.net/G_eorge/article/details/51144017
 
 */

// 滚动视图: 在页面中添加tableView，设置tableview距离四面【0，0，0，0】并设置tableview的背景色为red
- (IBAction)defualt:(id)sender {
    
    [self.navigationController pushViewController:[[DeafultViewController alloc] init] animated:YES];
}

// 非滚动视图半透明效果: 在tableview上方加一块青绿色的UILabel“紧贴着”tableview
- (IBAction)transDemo1:(id)sender {
    [self.navigationController pushViewController:[[TransDemo1VC alloc] init] animated:YES];
}

// 非滚动视图不需要半透明
- (IBAction)transDemo2:(id)sender {
    [self.navigationController pushViewController:[[TransDemo2VC alloc] init] animated:YES];
}

// 实现tableView每个group头部等高效果
- (IBAction)transDemo3:(id)sender {
    [self.navigationController pushViewController:[[TransDemo3VC alloc] init] animated:YES];
}

// 滚动视图半透明效果
- (IBAction)transDemo4:(id)sender {
    [self.navigationController pushViewController:[[TransDemo4VC alloc] init] animated:YES];
}

// 滚动视图不需要半透明
- (IBAction)transDemo5:(id)sender {
    [self.navigationController pushViewController:[[TransDemo1VC alloc] init] animated:YES];
}

@end
