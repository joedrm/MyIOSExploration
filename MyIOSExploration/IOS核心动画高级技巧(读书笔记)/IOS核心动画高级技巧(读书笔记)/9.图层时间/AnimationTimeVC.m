//
//  AnimationTimeVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/8.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "AnimationTimeVC.h"

@interface AnimationTimeVC ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *durationField;
@property (weak, nonatomic) IBOutlet UITextField *repeatField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) CALayer* shipLayer;
@property (strong, nonatomic) CALayer* doorLayer;
@end

@implementation AnimationTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self demo1];
//    [self demo2];
    [self demo5];
}


#pragma mark - CAMediaTiming协议
/*
 概念：CAMediaTiming协议定义了在一段动画内用来控制逝去时间的属性的集合，CALayer和CAAnimation都实现了这个协议，所以时间可以被任意基于一个图层或者一段动画的类控制。
 持续时间：“显式动画”中简单提到过duration（CAMediaTiming的属性之一），duration是一个CFTimeInterval的类型（类似于NSTimeInterval的一种双精度浮点类型），对将要进行的动画的一次迭代指定了时间
 重复次数：repeatCount，代表动画重复的迭代次数。如果duration是2，repeatCount设为3.5（三个半迭代），那么完整的动画时长将是7秒。
 */

- (void)demo1{

    CALayer* shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 152, 154);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"ship.jpeg"].CGImage);
    [self.containerView.layer addSublayer:shipLayer];
    self.shipLayer = shipLayer;
}

- (IBAction)start:(UIButton *)sender {
    
    CFTimeInterval duration = [self.durationField.text doubleValue];
    float repeatCount = [self.repeatField.text floatValue];
    
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:nil];
    [self setControlsEnabled:NO];
}

- (void)setControlsEnabled:(BOOL)enabled
{
    for (UIControl *control in @[self.durationField, self.repeatField, self.startButton]) {
        control.enabled = enabled;
        control.alpha = enabled? 1.0f: 0.25f;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self setControlsEnabled:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}



#pragma mark - repeatDuration
// 创建重复动画的另一种方式是使用repeatDuration属性，它让动画重复一个指定的时间，而不是指定次数。你甚至设置一个叫做autoreverses的属性（BOOL类型）在每次间隔交替循环过程中自动回放。
- (void)demo2{

    CALayer* doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 152, 154);
    doorLayer.position = CGPointMake(150 - 64, 150);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"door.jpg"].CGImage);
    [self.containerView.layer addSublayer:doorLayer];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = transform;
    
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI);
    animation.duration = 2.0;
    // 动画无限循环播放，设置repeatCount为INFINITY也有同样的效果，但是两个不能同时设置
    animation.repeatCount = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
}


#pragma mark - 相对时间
/*
 beginTime: 指定了动画开始之前的的延迟时间。这里的延迟从动画添加到可见图层的那一刻开始测量，默认是0（就是说动画会立刻执行）
 speed: 是一个时间的倍数，默认1.0，减少它会减慢图层/动画的时间，增加它会加快速度。如果2.0的速度，那么对于一个duration为1的动画，实际上在0.5秒的时候就已经完成了。
 timeOffset: 和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置timeOffset为0.5意味着动画将从一半的地方开始。
    和beginTime不同的是，timeOffset并不受speed的影响。所以如果你把speed设为2.0，把timeOffset设置为0.5，那么你的动画将从动画最后结束的地方开始，因为1秒的动画实际上被缩短到了0.5秒。然而即使使用了timeOffset让动画从结束的地方开始，它仍然播放了一个完整的时长，这个动画仅仅是循环了一圈，然后从头开始播放。
 */
- (void)demo3{
    
    [self.view removeAllSubviews];
    
}

#pragma mark - fillMode 填充
/* 
问题：对于beginTime非0的一段动画来说，会出现一个当动画添加到图层上但什么也没发生的状态，removeOnCompletion被设置为NO的动画将会在动画结束的时候仍然保持之前的状态。这就产生了一个问题，当动画开始之前和动画结束之后，被设置动画的属性将会是什么值呢？
解决：保持动画开始之前那一帧，或者动画结束之后的那一帧。这就是所谓的填充，因为动画开始和结束的值用来填充开始之前和结束之后的时间。这种行为可以被CAMediaTiming的fillMode来控制
 
fillMode是一个NSString类型，可以接受如下四种常量：
 
 kCAFillModeForwards
 kCAFillModeBackwards
 kCAFillModeBoth
 kCAFillModeRemoved
 
默认是kCAFillModeRemoved，当动画不再播放的时候就显示图层模型指定的值。剩下的三种类型分别为向前，向后或者既向前又向后去填充动画状态，使得动画在开始前或者结束后仍然保持开始和结束那一刻的值。
 
注意：1.把removeOnCompletion设置为NO， 2.需要给动画添加一个非空的键，3.在不需要动画的时候通过非空的键把它从图层上移除。
*/

- (void)demo4{

    
}

#pragma mark - 层级关系时间
/*
 1. 动画时间和它类似，每个动画和图层在时间上都有它自己的层级概念，相对于它的父亲来测量。对图层调整时间将会影响到它本身和子图层的动画，但不会影响到父图层。另一个相似点是所有的动画都被按照层级组合
 2. 对CALayer或者CAGroupAnimation调整duration和repeatCount/repeatDuration属性并不会影响到子动画。但是beginTime，timeOffset和speed属性将会影响到子动画。然而在层级关系中，beginTime指定了父图层开始动画（或者组合关系中的父动画）和对象将要开始自己动画之间的偏移。类似的，调整CALayer和CAGroupAnimation的speed属性将会对动画以及子动画速度应用一个缩放的因子。
 
 */

#pragma mark - 全局时间和本地时间
/*
 CoreAnimation有一个全局时间的概念，也就是所谓的马赫时间（“马赫”实际上是iOS和Mac OS系统内核的命名）你可以使用CACurrentMediaTime函数来访问马赫时间：
 CFTimeInterval time = CACurrentMediaTime();
 它真实的作用在于对动画的时间测量提供了一个相对值。注意当设备休眠的时候马赫时间会暂停，也就是所有的CAAnimations（基于马赫时间）同样也会暂停。
 
 CALayer同样也提供了方法来转换不同图层之间的本地时间:
 - (CFTimeInterval)convertTime:(CFTimeInterval)t fromLayer:(CALayer *)l;
 - (CFTimeInterval)convertTime:(CFTimeInterval)t toLayer:(CALayer *)l;
 用来同步不同图层之间有不同的speed，timeOffset和beginTime的动画，
 */

#pragma mark - 暂停，倒回和快进
/*
 我们想实现动画的暂停，倒回和快进碰到的问题
 问题：1. 设置动画的speed属性为0可以暂停动画，但在动画被添加到图层之后不太可能再修改它了，所以不能对正在进行的动画使用这个属性。
      2. 直接用-animationForKey:来检索图层正在进行的动画可以返回正确的动画对象，但是修改它的属性将会抛出异常。
      3. 如果移除图层正在进行的动画，图层将会急速返回动画之前的状态。但如果在动画移除之前拷贝呈现图层到模型图层，动画将会看起来暂停在那里。但是不好的地方在于之后就不能再恢复动画了。
 
 原因：给图层添加一个CAAnimation实际上是给动画对象做了一个不可改变的拷贝，所以对原始动画对象属性的改变对真实的动画并没有作用。
 
 解决：利用CAMediaTiming来暂停图层本身。如果把图层的speed设置成0，它会暂停任何添加到图层上的动画。类似的，设置speed大于1.0将会快进，设置成一个负值将会倒回动画。
 
 补充：通过增加主窗口图层的speed，可以暂停整个应用程序的动画。
      self.window.layer.speed = 100;
 */


#pragma mark - 手动动画
// timeOffset一个很有用的功能在于你可以它可以让你手动控制动画进程，通过设置speed为0，可以禁用动画的自动播放，然后来使用timeOffset来来回显示动画序列
// 还是上面关门的动画，修改代码来用手势控制动画。我们给视图添加一个UIPanGestureRecognizer，然后用timeOffset左右摇晃。
- (void)demo5{
    
    CALayer* doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(0, 0, 152, 154);
    doorLayer.position = CGPointMake(150 - 64, 150);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"door.jpg"].CGImage);
    [self.containerView.layer addSublayer:doorLayer];
    self.doorLayer = doorLayer;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = transform;
    
    // 添加手势
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    doorLayer.speed = 0.0;
    
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI);
    animation.duration = 1.0;
    // 动画无限循环播放，设置repeatCount为INFINITY也有同样的效果，但是两个不能同时设置
    animation.repeatCount = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGFloat x = [pan translationInView:self.view].x;
    x /= 200;
    CFTimeInterval timeOffSet = self.doorLayer.timeOffset;
    timeOffSet = MIN(0.999, timeOffSet - x);
    self.doorLayer.timeOffset = timeOffSet;
    [pan setTranslation:CGPointZero inView:self.view];
    
}
// 当然，可以用移动手势来直接设置门的transform来实现。
@end


























