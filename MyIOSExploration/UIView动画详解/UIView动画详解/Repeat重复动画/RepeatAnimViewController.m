//
//  RepeatAnimViewController.m
//  UIView动画详解
//
//  Created by wdy on 2017/2/21.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "RepeatAnimViewController.h"
#import <WDYLibrary/WDYLibrary.h>

@interface RepeatAnimViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *greenView;

@end

@implementation RepeatAnimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)viewDidLayoutSubviews{
    
    [UIView animateWithDuration:1 animations:^{
        self.blueView.centerX = self.view.width - 100;
    }];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.redView.centerX = self.view.width - 100;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        self.greenView.centerX = self.view.width - 100;
    } completion:^(BOOL finished) {
        
    }];
    /*
     UIViewAnimationOptions这个参数可以对动画的执行效果进行设置
     enum {
         //这部分是基础属性的设置
         UIViewAnimationOptionLayoutSubviews            = 1 <<  0,//设置子视图随父视图展示动画
         UIViewAnimationOptionAllowUserInteraction      = 1 <<  1,//允许在动画执行时用户与其进行交互
         UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2,//允许在动画执行时执行新的动画
         UIViewAnimationOptionRepeat                    = 1 <<  3,//设置动画循环执行
         UIViewAnimationOptionAutoreverse               = 1 <<  4,//设置动画反向执行，必须和重复执行一起使用
         UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5,//强制动画使用内层动画的时间值
         UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6,//强制动画使用内层动画曲线值
         UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7,//设置动画视图实时刷新
         UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8,//设置视图切换时隐藏，而不是移除
         UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9,//
         //这部分属性设置动画播放的线性效果
         UIViewAnimationOptionCurveEaseInOut            = 0 << 16,//淡入淡出 首末减速
         UIViewAnimationOptionCurveEaseIn               = 1 << 16,//淡入 初始减速
         UIViewAnimationOptionCurveEaseOut              = 2 << 16,//淡出 末尾减速
         UIViewAnimationOptionCurveLinear               = 3 << 16,//线性 匀速执行
         //这部分设置UIView切换效果
         UIViewAnimationOptionTransitionNone            = 0 << 20,
         UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,//从左边切入
         UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,//从右边切入
         UIViewAnimationOptionTransitionCurlUp          = 3 << 20,//从上面立体进入
         UIViewAnimationOptionTransitionCurlDown        = 4 << 20,//从下面立体进入
         UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,//溶解效果
         UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,//从上面切入
         UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,//从下面切入
     };
     
     */
}


@end













