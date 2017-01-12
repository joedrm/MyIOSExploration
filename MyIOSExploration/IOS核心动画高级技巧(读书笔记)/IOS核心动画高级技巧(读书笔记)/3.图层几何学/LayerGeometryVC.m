//
//  LayerGeometryVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2016/12/29.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "LayerGeometryVC.h"

@interface LayerGeometryVC ()
@property (nonatomic, strong) UIView* blueV;
@property (nonatomic, strong) CALayer* layer;
@end

@implementation LayerGeometryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    // 1. 布局： anchorPoint，默认 {0.5, 0.5}
    
    // 2. 坐标系
    // CALayer给不同坐标系之间的图层转换提供了一些工具类方法：
    /*
     - (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer;
     - (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer;
     - (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;
     - (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;
     */
    
    // 3. 翻转的几何结构
    // 常规说来，在iOS上，一个图层的position位于父图层的左上角，但是在Mac OS上，通常是位于左下角。Core Animation可以通过geometryFlipped属性来适配这两种情况，它决定了一个图层的坐标是否相对于父图层垂直翻转，是一个BOOL类型。在iOS上通过设置它为YES意味着它的子图层将会被垂直翻转，也就是将会沿着底部排版而不是通常的顶部（它的所有子图层也同理，除非把它们的geometryFlipped属性也设为YES）。
    
    
    // 4. Z坐标轴: zPosition和anchorPointZ，二者都是在Z轴上描述图层位置的浮点类型, 除了做变换之外，zPosition最实用的功能就是改变图层的显示顺序了
    UIView* greenV = [[UIView alloc] init];
    greenV.backgroundColor = [UIColor whiteColor];
    greenV.frame = CGRectMake(0, 0, 100, 100);
    greenV.center = self.view.center;
    [self.view addSubview:greenV];
    
    UIView* redV = [[UIView alloc] init];
    redV.backgroundColor = [UIColor whiteColor];
    redV.frame = CGRectMake(0, 0, 100, 100);
    redV.center = self.view.center;
    redV.y = self.view.centerY + 50;
    [self.view addSubview:redV];
    // 通过增加图层的zPosition，就可以把图层向相机方向前置，于是它就在所有其他图层的前面了
    greenV.layer.zPosition = 1.0;
    
    
    // 5. Hit Testing 图层的点击事件
    // CALayer并不关心任何响应链事件，所以不能直接处理触摸事件或者手势。但是它有一系列的方法帮你处理事件：-containsPoint:和-hitTest:
    UIView* blueV = [[UIView alloc] init];
    blueV.backgroundColor = [UIColor whiteColor];
    blueV.frame = CGRectMake(0, 0, 200, 200);
    blueV.viewOrigin = CGPointMake(10, kNavigationBarHeight);
    [self.view addSubview:blueV];
    self.blueV = blueV;
    
    CALayer* layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.position = blueV.layer.position;
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [blueV.layer addSublayer:layer];
    self.layer = layer;
    
    
    // 6. 自动布局
    // 如果想随意控制CALayer的布局，就需要手工操作。最简单的方法就是使用CALayerDelegate如下函数：
    // - (void)layoutSublayersOfLayer:(CALayer *)layer;
    // 当图层的bounds发生改变，或者图层的-setNeedsLayout方法被调用的时候，这个函数将会被执行。这使得你可以手动地重新摆放或者重新调整子图层的大小，但是不能像UIView的autoresizingMask和constraints属性做到自适应屏幕旋转。
    
}

// - containsPoint:接受一个在本图层坐标系下的CGPoint，如果这个点在图层frame范围内就返回YES
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [self.blueV.layer convertPoint:point toLayer:self.layer];
    if ([self.blueV.layer containsPoint:point]) {
        point = [self.layer convertPoint:point toLayer:self.blueV.layer];
        if ([self.layer containsPoint:point]) {
            [[[UIAlertView alloc] initWithTitle:@"点在蓝色图层上面"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"点在白色图层上面"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
}

// -hitTest:方法同样接受一个CGPoint类型参数，而不是BOOL类型，它返回图层本身，或者包含这个坐标点的叶子节点图层。这意味着不再需要像使用-containsPoint:那样，人工地在每个子图层变换或者测试点击的坐标。
// 注意当调用图层的-hitTest:方法时，测算的顺序严格依赖于图层树当中的图层顺序（和UIView处理事件类似）。zPosition属性可以明显改变屏幕上图层的顺序，但不能改变事件传递的顺序。这意味着如果改变了图层的z轴顺序，你会发现将不能够检测到最前方的视图点击事件，这是因为被另一个图层遮盖住了，虽然它的zPosition值较小，但是在图层树中的顺序靠前。
- (void)useHitTestWith:(NSSet<UITouch *> *)touches{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    CALayer* layer = [self.blueV.layer hitTest:point];
    if (layer == self.layer) {
        [[[UIAlertView alloc] initWithTitle:@"点在蓝色图层上面"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"点在白色图层上面"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


@end


















