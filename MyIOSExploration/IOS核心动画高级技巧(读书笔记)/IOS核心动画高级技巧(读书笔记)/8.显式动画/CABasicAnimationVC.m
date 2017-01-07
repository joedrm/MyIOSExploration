//
//  CABasicAnimationVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/2.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CABasicAnimationVC.h"

@interface CABasicAnimationVC ()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *testLayer;
@property (nonatomic, strong) CALayer *testLayer2;
@end

@implementation CABasicAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer* testLayer = [CALayer layer];
    testLayer.frame = CGRectMake(0, 0, 100, 100);
    testLayer.position = self.view.center;
    testLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:testLayer];
    self.testLayer = testLayer;
    
    CALayer* testLayer2 = [CALayer layer];
    testLayer2.frame = CGRectMake(10, kStatusBarAndNavigationBarHeight+10, 100, 100);
    testLayer2.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:testLayer2];
    self.testLayer2 = testLayer2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeColor5];
}

#pragma mark - 基础动画: CABasicAnimation

/*
 CABasicAnimation继承于CAPropertyAnimation，并添加了如下属性：
 
 id fromValue 代表了动画开始之前属性的值
 id toValue   代表了动画结束之后的值
 id byValue   代表了动画执行过程中改变的值。
 
 被定义成id类型而不是一些具体的类型是因为属性动画可以用作很多不同种的属性类型，包括数字类型，矢量，变换矩阵，甚至是颜色或者图片。需要把这些值用一个对象来封装，或者强转成一个对象， 为了防止冲突，不能一次性同时指定这三个值。
 CGFloat                NSNumber        id obj = @(float);
 CGPoint                NSValue         id obj = [NSValue valueWithCGPoint:point);
 CGSize                 NSValue         id obj = [NSValue valueWithCGSize:size);
 CGRect                 NSValue         id obj = [NSValue valueWithCGRect:rect);
 CATransform3D          NSValue         id obj = [NSValue valueWithCATransform3D:transform);
 CGImageRef             id              id obj = (__bridge id)imageRef;
 CGColorRef             id              id obj = (__bridge id)colorRef;
 */
- (void)changeColor{

    UIColor* bgColor = kRandomColor;
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.toValue = (__bridge id _Nullable)(bgColor.CGColor);
    anim.duration = 2.0;
    anim.removedOnCompletion = NO;
    
    [self.testLayer addAnimation:anim forKey:nil];
}

// 问题1：因为动画并没有改变图层的模型，一旦动画结束并从图层上移除之后，图层就立刻恢复到之前定义的外观状态。我们从没改变过backgroundColor属性，所以图层就返回到原始的颜色。
- (void)changeColor2{

    UIColor* bgColor = kRandomColor;
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.fromValue = (__bridge id)self.testLayer.backgroundColor;
    anim.keyPath = @"backgroundColor";
    anim.toValue = (__bridge id _Nullable)(bgColor.CGColor);
    anim.duration = 2.0;
    self.testLayer.backgroundColor = bgColor.CGColor;
    anim.removedOnCompletion = NO;
    
    [self.testLayer addAnimation:anim forKey:nil];
}

// 问题2：上面的做法还是有些问题，如果这里已经正在进行一段动画，我们需要从呈现图层那里去获得fromValue，而不是模型图层。另外，由于这里的图层并不是UIView关联的图层，我们需要用CATransaction来禁用隐式动画行为，否则默认的图层行为会干扰我们的显式动画

- (void)changeColor3{
    
    UIColor* bgColor = kRandomColor;
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.toValue = (__bridge id _Nullable)(bgColor.CGColor);
    anim.duration = 2.0;
    anim.removedOnCompletion = NO;
    [self applyBasicAnimation:anim toLayer:self.testLayer];
}

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer{
    
    animation.fromValue = [layer.presentationLayer ? layer.presentationLayer:layer valueForKey:animation.keyPath];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKey:animation.keyPath];
    [CATransaction commit];
    [layer addAnimation:animation forKey:nil];
}

// 问题3： 我们需要精准地在动画结束之后，图层返回到原始值之前更新属性，那么该如何找到这个点呢？怎么办到呢？下面介绍一下CAAnimationDelegate
#pragma mark - CAAnimationDelegate
- (void)changeColor4{
    
    UIColor* bgColor = kRandomColor;
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.toValue = (__bridge id _Nullable)(bgColor.CGColor);
//    anim.duration = 2.0;
    anim.delegate = self;
    anim.removedOnCompletion = NO;
    [self.testLayer addAnimation:anim forKey:nil];
}
// 用-animationDidStop:finished:方法在动画结束之后来更新图层的backgroundColor, * 由于下面要举例使用，这里先注释
//- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
//{
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.testLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
//    [CATransaction commit];
//}


// 问题4：就是当你有多个动画的时候，无法在在回调方法中区分。
// 解决: KVO，像所有的NSObject子类一样，CAAnimation实现了KVC（键-值-编码）协议，于是你可以用-setValue:forKey:和-valueForKey:方法来存取属性。但是CAAnimation有一个与众不同的特性：它更像一个NSDictionary，可以让你随意设置键值对，即使和你使用的动画类所声明的属性并不匹配。
- (void)test1{

    UIColor* bgColor = kRandomColor;
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.toValue = (__bridge id _Nullable)(bgColor.CGColor);
    anim.duration = 2.0;
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    [anim setValue:self.testLayer forKey:@"layer"];
    [self.testLayer addAnimation:anim forKey:nil];
    
    UIColor* bgColor1 = kRandomColor;
    CABasicAnimation* anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"backgroundColor";
    anim1.toValue = (__bridge id _Nullable)(bgColor1.CGColor);
    anim1.duration = 2.0;
    anim1.removedOnCompletion = NO;
    anim1.delegate = self;
    [anim1 setValue:self.testLayer forKey:@"layer2"];
    [self.testLayer2 addAnimation:anim forKey:nil];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    
//    CALayer* layer = [anim valueForKey:@"layer"];
//    
//}

// 问题5：changeColor4 在模拟器上运行的很好，但当真正跑在iOS设备上时，我们发现在-animationDidStop:finished:委托方法调用之前，指针会迅速返回到原始值
// 解决： fillMode属性
- (void)changeColor5{
    
    UIColor* bgColor = kRandomColor;
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.toValue = (__bridge id _Nullable)(bgColor.CGColor);
    anim.duration = 2.0;
    anim.delegate = self;
    anim.removedOnCompletion = NO;
    // 动画完成时的恢复状态：
    // kCAFillModeBackwards: 最后面的状态
    // kCAFillModeForwards: 最前面的状态
    anim.fillMode = kCAFillModeForwards;
    [self.testLayer addAnimation:anim forKey:nil];
    
    NSLog(@"%@", self.testLayer.backgroundColor);
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.testLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
    NSLog(@"%@", self.testLayer.backgroundColor);
}




@end
















