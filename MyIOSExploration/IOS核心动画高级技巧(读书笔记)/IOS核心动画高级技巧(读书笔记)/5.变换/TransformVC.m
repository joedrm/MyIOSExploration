//
//  TransformVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2016/12/29.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "TransformVC.h"
#import "CubeView.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5

@interface TransformVC ()
@property (nonatomic, strong) UIImageView* testV1;
@property (nonatomic, strong) UIView* containerV;
@property (nonatomic, strong) UIImageView* testV2;
@property (nonatomic, strong) UIImageView* testV3;

@property (nonatomic, strong) UIView *outerView;
@property (nonatomic, strong) UIView *innerView;

@property (nonatomic, strong) CubeView* cubeV;
@end

@implementation TransformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage* image = kImage(@"test.jpg");
    UIImageView* testV1 = [[UIImageView alloc] init];
    testV1.frame = CGRectMake(0, 0, image.size.width*0.5, image.size.height*0.5);
    testV1.center = self.view.center;
    testV1.image = kImage(@"test.jpg");
    [self.view addSubview:testV1];
    self.testV1 = testV1;
    
    UIView* containerV = [[UIView alloc] init];
    containerV.backgroundColor = [UIColor lightGrayColor];
    containerV.frame = CGRectMake(0, CGRectGetMaxY(testV1.frame) +10, kScreenWidth, 200);
    [self.view addSubview:containerV];
    self.containerV = containerV;
    
    UIImageView* testV2 = [[UIImageView alloc] init];
    testV2.frame = CGRectMake(0, 0, 100, self.containerV.height);
    testV2.center = CGPointMake(self.containerV.width*0.25, self.containerV.height*0.5);
    testV2.image = kImage(@"test.jpg");
    [self.containerV addSubview:testV2];
    self.testV2 = testV2;
    
    UIImageView* testV3 = [[UIImageView alloc] init];
    testV3.frame = CGRectMake(0, 0, 100, self.containerV.height);
    testV3.center = CGPointMake(self.containerV.width*0.75, self.containerV.height*0.5);
    testV3.image = kImage(@"test.jpg");
    [self.containerV addSubview:testV3];
    self.testV3 = testV3;
    
    UIView* outerView = [[UIView alloc] init];
    outerView.frame = CGRectMake(0, testV1.top - 150, 150, 150);
    outerView.centerX = self.view.centerX;
    outerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:outerView];
    self.outerView = outerView;
    
    UIView* innerView = [[UIView alloc] init];
    innerView.frame = CGRectMake((self.outerView.width - 100)*.5, (self.outerView.height - 100)*.5, 100, 100);
//    innerView.center = self.outerView.center;
    innerView.backgroundColor = [UIColor redColor];
    [self.outerView addSubview:innerView];
    self.innerView = innerView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self test10];
}

#pragma mark - 1.仿射变换 CGAffineTransform
// UIView的transform属性是一个CGAffineTransform类型，用于在二维空间做旋转，缩放和平移。CGAffineTransform是一个可以和二维空间向量（例如CGPoint）做乘法的3X2的矩阵, UIView可以通过设置transform属性做变换，但实际上它只是封装了内部图层的变换。CALayer同样也有一个transform属性，但它的类型是CATransform3D，而不是CGAffineTransform，CALayer对应于UIView的transform属性叫做affineTransform
// CGAffineTransform 类型属于 Core Graphics 框架，对应layer的属性是：affineTransform
// 对图层旋转45度
- (void)test1{
    
    self.testV1.layer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
}

#pragma mark - 2.混合变换
// 按顺序做了变换，上一个变换的结果将会影响之后的变换，这意味着变换的顺序会影响最终的结果，也就是说旋转之后的平移和平移之后的旋转结果可能不同。
- (void)test2{

    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 0.5, 0.5);//缩小
    transform = CGAffineTransformRotate(transform, M_PI/180 * 30);// 旋转
    transform = CGAffineTransformTranslate(transform, 100, 0);// 平移
    self.testV1.layer.affineTransform = transform;
}

#pragma mark - 3.剪切变换
// 斜切变换是放射变换的第四种类型，较于平移，旋转和缩放并不常用
- (void)test3{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -1;
    transform.b = 0;
    self.testV1.layer.affineTransform = transform;
}

#pragma mark - 4.3D变换 CATransform3D
// a. 和CGAffineTransform类似，CATransform3D也是一个矩阵，但是和2x3的矩阵不同，CATransform3D是一个可以在3维空间内做变换的4x4的矩阵
// b. 绕Z轴的旋转等同于之前二维空间的仿射旋转，但是绕X轴和Y轴的旋转就突破了屏幕的二维空间，并且在用户视角看来发生了倾斜。
// c. CATransform3D 属于 Core Animation 框架, 对应layer的属性是：transform
- (void)test4{
    // 视图看起来更窄实际上是因为我们在用一个斜向的视角看它，而不是透视
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.testV1.layer.transform = transform;
}

#pragma mark - 5.透视投影
// CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制：m34，用于按比例缩放X和Y的值来计算到底要离视角多远。
// m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，实际上并不需要，大概估算一个就好了。通常500-1000就已经很好了
- (void)test5{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    self.testV1.layer.transform = transform;
}

#pragma mark - 6.灭点
// 当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。
// Core Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置。
// 当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
- (void)test6{


}

#pragma mark - 7.sublayerTransform属性
// a. CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
//
- (void)test7{

    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    self.containerV.layer.sublayerTransform = perspective;
    
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.testV2.layer.transform = transform1;
    
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    self.testV3.layer.transform = transform2;
}

#pragma mark - 8.背面
// CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。


#pragma mark - 9.扁平化图层
/*
 内部的图层仍然向左侧旋转，并且发生了扭曲，但按道理说它应该保持正面朝上，并且显示正常的方块。
 这是由于尽管Core Animation图层存在于3D空间之内，但它们并不都存在同一个3D空间。每个图层的3D场景其实是扁平化的，当你从正面观察一个图层，看到的实际上由子图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面。
 
 类似的，当你在玩一个3D游戏，实际上仅仅是把屏幕做了一次倾斜，或许在游戏中可以看见有一面墙在你面前，但是倾斜屏幕并不能够看见墙里面的东西。所有场景里面绘制的东西并不会随着你观察它的角度改变而发生变化；图层也是同样的道理。
 
 这使得用Core Animation创建非常复杂的3D场景变得十分困难。你不能够使用图层树去创建一个3D结构的层级关系--在相同场景下的任何3D表面必须和同样的图层保持一致，这是因为每个的父视图都把它的子视图扁平化了。
 */
- (void)test9{
    
    CATransform3D outer = CATransform3DIdentity;
    outer.m34 = -1.0 / 500.0;
    outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
    self.outerView.layer.transform = outer;
    
    CATransform3D inner = CATransform3DIdentity;
    inner.m34 = -1.0 / 500.0;
    inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
    self.innerView.layer.transform = inner;
}



#pragma mark - 固体对象 (立方体)

- (void)test10{
    [self.view addSubview:self.cubeV];
    
    CGFloat WH = 150;
    CGFloat trans = WH*.5;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, trans);
    // 添加六个字View
    for (int i = 0; i < 6; i ++) {
        
        UILabel* faceV = [[UILabel alloc] init];
        faceV.backgroundColor = [UIColor whiteColor];
        faceV.frame = CGRectMake(0, 0, WH, WH);
        faceV.center = CGPointMake(WH, WH);
        faceV.textAlignment = NSTextAlignmentCenter;
        faceV.text = [NSString stringWithFormat:@"%d",(i + 1)];
        faceV.textColor = kRandomColor;
        faceV.font = kFontWithSize(16);
        faceV.layer.borderColor = [UIColor grayColor].CGColor;
        faceV.layer.borderWidth = 1.0;
        
        [self.cubeV addSubview:faceV];
        if (i == 0) {
            faceV.layer.transform = transform;
        }else if(i == 1){
            transform = CATransform3DMakeTranslation(trans, 0, 0);//x轴先平移75，刚好中心点在第一个view的最右边
            transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);//y轴旋转90度，此时正好垂直在第一个view的后面
            faceV.layer.transform = transform;
        }else if(i == 2){
            transform = CATransform3DMakeTranslation(0, -trans, 0);
            transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
            faceV.layer.transform = transform;
        }else if(i == 3){
            transform = CATransform3DMakeTranslation(0, trans, 0);
            transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
            faceV.layer.transform = transform;
        }else if(i == 4){
            transform = CATransform3DMakeTranslation(-trans, 0, 0);
            transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
            faceV.layer.transform = transform;
        }else if(i == 5){
            transform = CATransform3DMakeTranslation(0, 0, -trans);
            transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
            faceV.layer.transform = transform;
        }
        [self applyLightingToFace:faceV.layer];
    }
}

- (void)applyLightingToFace:(CALayer *)face
{
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //convert the face transform to matrix
    //(GLKMatrix4 has the same structure as CATransform3D)
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}

- (CubeView *)cubeV{

    if (!_cubeV) {
        _cubeV = [CubeView cubeView];
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0/500;
        perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
        perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
        _cubeV.layer.sublayerTransform = perspective;
        _cubeV.center = self.view.center;
        
        
    }
    return _cubeV;
}

#pragma mark - 11.光亮和阴影
/*
 现在它看起来更像是一个立方体没错了，但是对每个面之间的连接还是很难分辨。Core Animation可以用3D显示图层，但是它对光线并没有概念。如果想让立方体看起来更加真实，需要自己做一个阴影效果。你可以通过改变每个面的背景颜色或者直接用带光亮效果的图片来调整。
 */
- (void)test11{
    
    
    
}
@end






















