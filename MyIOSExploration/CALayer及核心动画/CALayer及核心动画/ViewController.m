//
//  ViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

/*
 参考资料：
 
 https://github.com/xiaochaofeiyu/YSCAnimation
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
                      @"转盘动画"];
    
    self.vcArr = @[@"CATransformVC",
                   @"CustomLayerVC",
                   @"ClockViewController",
                   @"CABasicAnimationVC",
                   @"HeartBeatEffectVC",
                   @"CAKeyframeAnimationVC",
                   @"CATransitionDemoVC",
                   @"CAAnimationGroupVC",
                   @"WheelViewController"
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

