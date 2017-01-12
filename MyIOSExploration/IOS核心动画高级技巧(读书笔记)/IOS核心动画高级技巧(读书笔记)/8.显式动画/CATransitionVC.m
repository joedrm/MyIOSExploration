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

    [self performTransition];
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
#pragma mark - CATransition 过度动画
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


/*
 通过UIView +transitionFromView:toView:duration:options:completion:和+transitionWithView:duration:options:animations:方法提供了Core Animation的过渡特性。
 但是这里的可用的过渡选项和CATransition的type属性提供的常量完全不同。UIView过渡方法中options参数可以由如下常量指定：
 
 UIViewAnimationOptionTransitionFlipFromLeft
 UIViewAnimationOptionTransitionFlipFromRight
 UIViewAnimationOptionTransitionCurlUp
 UIViewAnimationOptionTransitionCurlDown
 UIViewAnimationOptionTransitionCrossDissolve
 UIViewAnimationOptionTransitionFlipFromTop
 UIViewAnimationOptionTransitionFlipFromBottom
 
 除了UIViewAnimationOptionTransitionCrossDissolve之外，剩下的值和CATransition类型完全没关系
 
 */
#pragma mark - UIView实现 过度动画
- (void)changeImage2{
    
    [UIView transitionWithView:self.testImageV duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        UIImage *currentImage = self.testImageV.image;
                        NSUInteger index = [self.items indexOfObject:currentImage];
                        index = (index + 1) % [self.items count];
                        self.testImageV.image = self.items[index];
                    }
                    completion:NULL];
}


#pragma mark - 创建自定义过渡效果
/*
 过渡动画做基础的原则就是对原始的图层外观截图，然后添加一段动画，平滑过渡到图层改变之后那个截图的效果。如果我们知道如何对图层截图，我们就可以使用属性动画来代替CATransition或者是UIKit的过渡方法来实现动画。
 CALayer有一个-renderInContext:方法，可以通过把它绘制到Core Graphics的上下文中捕获当前内容的图片，然后在另外的视图中显示出来。如果我们把这个截屏视图置于原始视图之上，就可以遮住真实视图的所有变化，于是重新创建了一个简单的过渡效果。
 */
- (void)performTransition{

    // 对控制器的View截图
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctx];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImageView* coverView = [[UIImageView alloc] initWithImage:image];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    self.view.backgroundColor = kRandomColor;
    [UIView animateWithDuration:2.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
    
}

#pragma mark - 在动画过程中取消动画
/*
 - (CAAnimation *)animationForKey:(NSString *)key; 用-addAnimation:forKey:方法中的key参数来在添加动画之后检索一个动画，但并不支持在动画运行过程中修改动画，所以这个方法主要用来检测动画的属性，或者判断它是否被添加到当前图层中。
 - (void)removeAnimationForKey:(NSString *)key;或者移除所有动画：- (void)removeAllAnimations; 终止一个指定的动画，你可以把它从图层移除掉：
 
 一般说来，动画在结束之后被自动移除，除非设置removedOnCompletion为NO，如果你设置动画在结束之后不被自动移除，那么当它不需要的时候你要手动移除它；否则它会一直存在于内存中，直到图层被销毁。
 */

@end







