//
//  ViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

/*
 参考资料：
 
 学习步骤
 1. https://github.com/AttackOnDobby/iOS-Core-Animation-Advanced-Techniques
    demo:https://github.com/huang303513/HCDCoreAnimation
 
 2. https://github.com/KittenYang/A-GUIDE-TO-iOS-ANIMATION
 
 3. https://github.com/YouXianMing/Animations   
    https://github.com/YouXianMing/YoCelsius
    https://github.com/YouXianMing/UI-Component-Collection
 
 
 http://www.jianshu.com/p/78c30ccf425f  CATransform3D笔记 https://github.com/HApple/CATransform3D
 
 
 https://github.com/xiaochaofeiyu/YSCAnimation
 IOS动画总结:https://github.com/yixiangboy/IOSAnimationDemo
 https://github.com/wangtongke/WTKTransitionAnimate
 https://github.com/wangtongke/WTKTransitionAnimation
 https://github.com/weng1250/WZLBadge
 https://github.com/a130785/iosAnimationDemo
 https://github.com/shu223/AnimatedTransitionGallery
 https://github.com/jhurray/JHChainableAnimations
 https://github.com/adad184/MMTweenAnimation
 
 
 Facebook-POP
 
 intro
 http://www.cocoachina.com/industry/20140704/9034.html
 http://www.cocoachina.com/design/20140210/7791.html
 http://www.cocoachina.com/industry/20140527/8565.html
 github
 https://github.com/facebook/pop
 https://github.com/schneiderandre/popping
 https://github.com/hossamghareeb/Facebook-POP-Tutorial
 https://github.com/ColinEberhardt/VCTransitionsLibrary
 */

#import "ViewController.h"

static NSString* AnimationIdentifier = @"AnimationIdentifier";

@interface ViewController ()


@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, strong) NSArray* vcArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CALayer及核心动画";
    self.titleArr = @[@"CATransform3D",
                      @"自定义Layer",
                      @"时钟动画",
                      @"CABasicAnimation(基础核心动画)",
                      @"心跳效果",
                      @"CAKeyframeAnimation(图片抖动)",
                      @"CATransition转场动画",
                      @"CAAnimationGroup(动画组)",
                      @"转盘动画",
                      @"图片折叠",
                      @"播放器音量震动条",
                      @"粒子效果",
                      @"仿QQ粘性布局"];
    
    self.vcArr = @[@"CATransformVC",
                   @"CustomLayerVC",
                   @"ClockViewController",
                   @"CABasicAnimationVC",
                   @"HeartBeatEffectVC",
                   @"CAKeyframeAnimationVC",
                   @"CATransitionDemoVC",
                   @"CAAnimationGroupVC",
                   @"MyWheelViewController",
                   @"ImageFoldViewController",
                   @"VoiceShakeViewController",
                   @"ParticleEffectViewController",
                   @"QQViewController"
                   ];
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AnimationIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:AnimationIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AnimationIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id class = NSClassFromString(self.vcArr[indexPath.row]);
    UIViewController* vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

