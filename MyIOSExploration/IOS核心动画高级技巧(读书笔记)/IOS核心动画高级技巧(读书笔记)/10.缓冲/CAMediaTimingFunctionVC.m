//
//  CAMediaTimingFunctionVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CAMediaTimingFunctionVC.h"

@interface CAMediaTimingFunctionVC ()
@property (nonatomic, strong) CALayer* test1Layer;
@property (nonatomic, strong) UIView* test2View;
@property (nonatomic, strong) CALayer* test3Layer;
@property (nonatomic, strong) UIView* test4View;
@property (nonatomic, strong) UIImageView* ballView;
@end

@implementation CAMediaTimingFunctionVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
    [self test5];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self test1Fun:touches];
//    [self test2Fun:touches];
//    [self chageColor];
//    [self test5Fun];
    [self test6];
}

#pragma mark - 动画速度
/*
 一辆车行驶在一定距离内，它并不会一开始就以60mph的速度行驶，然后到达终点后突然变成0mph。一是因为需要无限大的加速度（即使是最好的车也不会在0秒内从0跑到60），另外不然的话会干死所有乘客。在现实中，它会慢慢地加速到全速，然后当它接近终点的时候，它会慢慢地减速，直到最后停下来。
 现实生活中的任何一个物体都会在运动中加速或者减速。那么我们如何在动画中实现这种加速度呢？一种方法是使用物理引擎来对运动物体的摩擦和动量来建模，然而这会使得计算过于复杂。我们称这种类型的方程为缓冲函数，幸运的是，Core Animation内嵌了一系列标准函数提供给我们使用。
 */


#pragma mark - CAMediaTimingFunction
/*
CAAnimation的timingFunction属性，是CAMediaTimingFunction类的一个对象。如果想改变隐式动画的计时函数，同样也可以使用CATransaction的+setAnimationTimingFunction:方法。
 CAMediaTimingFunction，最简单的方式是调用+timingFunctionWithName:的构造方法。这里传入如下几个常量之一：
 
 kCAMediaTimingFunctionLinear    一个线性的计时函数,同样也是CAAnimation的timingFunction属性为空时候的默认函数。
 kCAMediaTimingFunctionEaseIn    一个慢慢加速然后突然停止的方法，对于之前提到的自由落体的例子来说很适合，或者比如对准一个目标的导弹的发射。
 kCAMediaTimingFunctionEaseOut   它以一个全速开始，然后慢慢减速停止。它有一个削弱的效果，应用的场景比如一扇门慢慢地关上，而不是砰地一声。
 kCAMediaTimingFunctionEaseInEaseOut  一个慢慢加速然后再慢慢减速的过程。这是现实世界大多数物体移动的方式，也是大多数动画来说最好的选择。当使用UIView的动画方法时，他是默认的，但当创建CAAnimation的时候，就需要手动设置它了。
 kCAMediaTimingFunctionDefault   它和kCAMediaTimingFunctionEaseInEaseOut很类似，但是加速和减速的过程都稍微有些慢。虽然它的名字说是默认的，但还是要记住当创建显式的CAAnimation它并不是默认选项（换句话说，默认的图层行为动画用kCAMediaTimingFunctionDefault作为它们的计时方法）
*/
- (void)test1{
    
    self.test1Layer = [CALayer layer];
    self.test1Layer.backgroundColor = [UIColor redColor].CGColor;
    self.test1Layer.frame = CGRectMake(0, 0, 100, 100);
    self.test1Layer.position = CGPointMake(self.view.width*0.5, self.view.height*0.5);
    [self.view.layer addSublayer:self.test1Layer];
}

- (void)test1Fun:(NSSet<UITouch *> *)touches{

    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.test1Layer.position = [[touches anyObject] locationInView:self.view];
    [CATransaction commit];
}

#pragma mark - UIView的动画缓冲
// UIKit的动画也同样支持这些缓冲方法的使用，尽管语法和常量有些不同，为了改变UIView动画的缓冲选项，给options参数添加如下常量之一：
/*
 UIViewAnimationOptionCurveEaseInOut
 UIViewAnimationOptionCurveEaseIn    默认值
 UIViewAnimationOptionCurveEaseOut
 UIViewAnimationOptionCurveLinear
 */

- (void)test2{

    self.test2View = [[UIView alloc] init];
    self.test2View.backgroundColor = [UIColor redColor];
    self.test2View.frame = CGRectMake(0, 0, 100, 100);
    self.test2View.center = CGPointMake(self.view.width*0.5, self.view.height*0.5);
    [self.view addSubview:self.test2View];
}

- (void)test2Fun:(NSSet<UITouch *> *)touches{
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.test2View.center = [[touches anyObject] locationInView:self.view];
    } completion:nil];
}

#pragma mark - 缓冲和关键帧动画
/*
 CAKeyframeAnimation有一个NSArray类型的timingFunctions属性，我们可以用它来对每次动画的步骤指定不同的计时函数。
 但是指定函数的个数一定要等于keyframes数组的元素个数减一，因为它是描述每一帧之间动画速度的函数。
 */
- (void)test3{

    self.test3Layer = [CALayer layer];
    self.test3Layer.backgroundColor = [UIColor redColor].CGColor;
    self.test3Layer.frame = CGRectMake(0, 0, 100, 100);
    self.test3Layer.position = CGPointMake(self.view.width*0.5, self.view.height*0.5);
    [self.view.layer addSublayer:self.test3Layer];
}

- (void)chageColor{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[(__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor orangeColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor];
    CAMediaTimingFunction* timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[timing, timing, timing];
    [self.test3Layer addAnimation:animation forKey:nil];
}

#pragma mark - 自定义缓冲函数
/*
 CAMediaTimingFunction同样有另一个构造函数，一个有四个浮点参数的+functionWithControlPoints:::: 使用这个方法，我们可以创建一个自定义的缓冲函数，
 
 CAMediaTimingFunction是如何工作的?
 CAMediaTimingFunction函数的主要原则在于它把输入的时间转换成起点和终点之间成比例的改变。
 CAMediaTimingFunction函数的主要原则在于它把输入的时间转换成起点和终点之间成比例的改变。我们可以用一个简单的图标来解释，横轴代表时间，纵轴代表改变的量，于是线性的缓冲就是一条从起点开始的简单的斜线
 CAMediaTimingFunction使用了一个叫做三次贝塞尔曲线的函数，它只可以产出指定缓冲函数的子集
 一个三次贝塞尔曲线通过四个点来定义，第一个和最后一个点代表了曲线的起点和终点，剩下中间两个点叫做控制点，因为它们控制了曲线的形状，贝塞尔曲线的控制点其实是位于曲线之外的点，也就是说曲线并不一定要穿过它们。你可以把它们想象成吸引经过它们曲线的磁铁。
 CAMediaTimingFunction有一个叫做-getControlPointAtIndex:values:的方法，可以用来检索曲线的点，使用它我们可以找到标准缓冲函数的点，然后用UIBezierPath和CAShapeLayer来把它画出来。
 */

- (void)test4{
    
    self.test4View = [[UIView alloc] init];
    self.test4View.backgroundColor = [UIColor lightGrayColor];
    self.test4View.frame = CGRectMake(0, 0, 200, 200);
    self.test4View.center = CGPointMake(self.view.width*0.5, self.view.height*0.5);
    [self.view addSubview:self.test4View];
    
//    CAMediaTimingFunction* fun = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 自定义时钟的缓冲函数
    CAMediaTimingFunction* fun = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
    
    CGPoint point1, point2;
    float c1p[2], c2p[2];
    // 得到两个控制点
//    [fun getControlPointAtIndex:1 values:(float*)&point1];
//    [fun getControlPointAtIndex:2 values:(float*)&point2];
    [fun getControlPointAtIndex:1 values:c1p];
    [fun getControlPointAtIndex:2 values:c2p];
    // 这里好像拿不到两个点 http://stackoverflow.com/questions/31800020/getcontrolpointatindex-parameter-type
    NSLog(@"point1 = %@, point2 = %@", NSStringFromCGPoint(point1), NSStringFromCGPoint(point2));
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addCurveToPoint:CGPointMake(200, 200) controlPoint1:point1 controlPoint2:point2];
//    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 4.0;
    layer.path = path.CGPath;
    
    [self.test4View.layer addSublayer:layer];
    self.test4View.layer.geometryFlipped = YES;
}

#pragma mark - 更加复杂的动画曲线

/*
 动画场景：一个橡胶球掉落到坚硬的地面的场景，当开始下落的时候，它会持续加速知道落到地面，然后经过几次反弹，最后停下来。这种效果没法用一个简单的三次贝塞尔曲线表示
 
 可以用如下几种方法：
 
 用CAKeyframeAnimation创建一个动画，然后分割成几个步骤，每个小步骤使用自己的计时函数（具体下节介绍）。
 使用定时器逐帧更新实现动画（见第11章，“基于定时器的动画”）。
 
 */

#pragma mark - 基于关键帧的缓冲
/*
 为了使用关键帧实现反弹动画，我们需要在缓冲曲线中对每一个显著的点创建一个关键帧（在这个情况下，关键点也就是每次反弹的峰值），然后应用缓冲函数把每段曲线连接起来。同时，我们也需要通过keyTimes来指定每个关键帧的时间偏移，由于每次反弹的时间都会减少，于是关键帧并不会均匀分布。
 */
- (void)test5{

    self.test4View = [[UIView alloc] init];
    self.test4View.backgroundColor = [UIColor lightGrayColor];
    self.test4View.frame = CGRectMake(0, 0, 300, 400);
    self.test4View.center = CGPointMake(self.view.width*0.5, self.view.height*0.5);
    [self.view addSubview:self.test4View];
    
    self.ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball.jpg"]];
    self.ballView.frame = CGRectMake(0, 0, 50, 50);
    self.ballView.centerX = 150;
    [self.test4View addSubview:self.ballView];
}

- (void)test5Fun{
    self.ballView.center = CGPointMake(150, 32);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)]
                         ];
    
    animation.timingFunctions = @[
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                          [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
                                  ];
    
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    self.ballView.layer.position = CGPointMake(150, 268);
    [self.ballView.layer addAnimation:animation forKey:nil];
}

#pragma mark - 流程自动化
/*
 为了实现自动化，我们需要知道如何做如下两件事情：
 
 自动把任意属性动画分割成多个关键帧
 用一个数学函数表示弹性动画，使得可以对帧做便宜
 为了解决第一个问题，我们需要复制Core Animation的插值机制。这是一个传入起点和终点，然后在这两个点之间指定时间点产出一个新点的机制。
 
 那么如果要插入一个类似于CGPoint，CGColorRef或者CATransform3D这种更加复杂类型的值，我们可以简单地对每个独立的元素应用这个方法（也就CGPoint中的x和y值，CGColorRef中的红，蓝，绿，透明值，或者是CATransform3D中独立矩阵的坐标）。我们同样需要一些逻辑在插值之前对对象拆解值，然后在插值之后在重新封装成对象，也就是说需要实时地检查类型。
 
 一旦我们可以用代码获取属性动画的起始值之间的任意插值，我们就可以把动画分割成许多独立的关键帧，然后产出一个线性的关键帧动画。
 */
- (void)test6{

    self.test4View = [[UIView alloc] init];
    self.test4View.backgroundColor = [UIColor lightGrayColor];
    self.test4View.frame = CGRectMake(0, 0, 300, 400);
    self.test4View.center = CGPointMake(self.view.width*0.5, self.view.height*0.5);
    [self.view addSubview:self.test4View];
    
    self.ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball.jpg"]];
    self.ballView.frame = CGRectMake(0, 0, 50, 50);
    self.ballView.centerX = 150;
    [self.test4View addSubview:self.ballView];
    
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0;
    // 用了60 x 动画时间（秒做单位）作为关键帧的个数，这时因为Core Animation按照每秒60帧去渲染屏幕更新，所以如果我们每秒生成60个关键帧，就可以保证动画足够的平滑
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1 / (float)numFrames * i;
        time = bounceEaseOut(time);
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.values = frames;
    
    [self.ballView.layer addAnimation:animation forKey:nil];
}

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    return (time < 0.5)? fromValue: toValue;
}

//缓冲背后的数学并不很简单，但是幸运的是我们不需要一一实现它。罗伯特·彭纳有一个网页关于缓冲函数（http://www.robertpenner.com/easing），包含了大多数普遍的缓冲函数的多种编程语言的实现的链接，包括C。这里是一个缓冲进入缓冲退出函数的示例
// https://github.com/warrenm/AHEasing  A library of easing functions for C, C++ and Objective-C
float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

@end

















