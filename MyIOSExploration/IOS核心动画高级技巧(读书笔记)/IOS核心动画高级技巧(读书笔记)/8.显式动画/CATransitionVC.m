//
//  CATransitionVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/7.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CATransitionVC.h"

@interface CATransitionVC ()
@property (nonatomic, strong) UIImageView* testImageV;
@property (nonatomic, strong) NSArray* items;
@end

@implementation CATransitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[[UIImage imageNamed:@"name01.jpeg"],
                   [UIImage imageNamed:@"name02.jpeg"],
                   [UIImage imageNamed:@"name03.jpeg"],
                   [UIImage imageNamed:@"name04.jpeg"]];
    
    UIImageView* imageV = [[UIImageView alloc] init];
    imageV.frame = CGRectMake(0, 0, 200, 300);
    imageV.center = self.view.center;
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"name01.jpeg"];
    self.testImageV = imageV;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self changeImage];
}

/*
 属性动画只对图层的可动画属性起作用，所以如果要改变一个不能动画的属性（比如图片），或者从层级关系中添加或者移除图层，属性动画将不起作用。
 过渡并不像属性动画那样平滑地在两个值之间做动画，而是影响到整个图层的变化。过渡动画首先展示之前的图层外观，然后通过一个交换过渡到新的外观。
 CATransition，同样是另一个CAAnimation的子类，和别的子类不同，CATransition有一个type和subtype来标识变换效果。type属性是一个NSString类型，
 可以被设置成如下类型：

 kCATransitionFade
 kCATransitionMoveIn
 kCATransitionPush
 kCATransitionReveal
 
 默认的过渡类型是kCATransitionFade
 
 通过subtype来控制它们的方向:
 
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromTop
 kCATransitionFromBottom
 
 */

- (void)changeImage{

    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    [self.testImageV.layer addAnimation:transition forKey:nil];
    UIImage *currentImage = self.testImageV.image;
    NSUInteger index = [self.items indexOfObject:currentImage];
    index = (index + 1) % [self.items count];
    self.testImageV.image = self.items[index];
}
//和属性动画不同的是，对指定的图层一次只能使用一次CATransition，因此，无论你对动画的键设置什么值，过渡动画都会对它的键设置成“transition”，也就是常量kCATransition。
@end







