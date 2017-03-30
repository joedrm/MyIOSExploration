//
//  CATransformLayerVC.m
//  IOS核心动画高级技巧(读书笔记)
//
//  Created by wdy on 2017/1/1.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "CATransformLayerVC.h"

@interface CATransformLayerVC ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation CATransformLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0/500.0;
    self.containerView.layer.sublayerTransform = transform3D;
    
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -70, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.containerView.layer addSublayer:cube1];
    
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 70, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];
}

- (CALayer*)cubeWithTransform:(CATransform3D)transform{

    CATransformLayer *cube = [CATransformLayer layer];
    //face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    CGSize containerSize = self.containerView.viewSize;
    cube.position = CGPointMake(containerSize.width*0.5, containerSize.height*0.5);
    
    cube.transform = transform;
    return cube;
}

- (CALayer*)faceWithTransform:(CATransform3D)transform{

    CALayer* face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    face.backgroundColor = kRandomColor.CGColor;
    face.transform = transform;
    return face;
}

@end
