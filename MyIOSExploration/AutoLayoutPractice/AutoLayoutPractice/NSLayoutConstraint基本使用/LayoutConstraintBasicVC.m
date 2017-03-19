//
//  LayoutConstraintBasicVC.m
//  AutoLayoutPractice
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "LayoutConstraintBasicVC.h"

@interface LayoutConstraintBasicVC ()

@end


@implementation LayoutConstraintBasicVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    http://www.cocoachina.com/ios/20160616/16732.html
    
    /*
     附视图的属性和关系的值:
     typedef NS_ENUM(NSInteger, NSLayoutRelation) {
         NSLayoutRelationLessThanOrEqual = -1,          //小于等于
         NSLayoutRelationEqual = 0,                     //等于
         NSLayoutRelationGreaterThanOrEqual = 1,        //大于等于
     };
     
     typedef NS_ENUM(NSInteger, NSLayoutAttribute) {
         NSLayoutAttributeLeft = 1,                     //左侧
         NSLayoutAttributeRight,                        //右侧
         NSLayoutAttributeTop,                          //上方
         NSLayoutAttributeBottom,                       //下方
         NSLayoutAttributeLeading,                      //首部
         NSLayoutAttributeTrailing,                     //尾部
         NSLayoutAttributeWidth,                        //宽度
         NSLayoutAttributeHeight,                       //高度
         NSLayoutAttributeCenterX,                      //X轴中心
         NSLayoutAttributeCenterY,                      //Y轴中心
         NSLayoutAttributeBaseline,                     //文本底标线
         
         NSLayoutAttributeNotAnAttribute = 0            //没有属性
     };
     */
    
    /*
     NSLayoutConstraint* constraint = [NSLayoutConstraint
                                         constraintWithItem:nil
                                         attribute:nil
                                         relatedBy:nil
                                         toItem:nil
                                         attribute:nil
                                         multiplier:0
                                         constant:0];
     +(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
     view1: 要约束的控件（purpleView）
     attr1: 约束的类型（常量），就是要做怎么样的约束，大家可以进去看看都有什么常量（这里是NSLayoutAttributeLeft）
     relation: 与参照控件之间的关系（常量），包括等于、大于等于、小于等于（NSLayoutRelationEqual 是指等于）
     view2: 参照的控件（self.view）
     attr2: 约束的类型（常量），就是要做怎么样的约束，大家可以进去看看都有什么常量（这里是NSLayoutAttributeLeft）（NSLayoutAttributeLeft）
     multiplier: 乘数，就是多少倍（1.0）
     c: 常量，做好了上述的约束之后会加上这个常量（100）
     */
    
    
    [self test1];
    [self test2];
}


- (void)test1{

    UIView* redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    // 禁止autoresizing自动转换为约束
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    // 添加宽度约束
    NSLayoutConstraint* widthCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:100];
    [redView addConstraint:widthCon];
    
    // 添加高度约束
    NSLayoutConstraint* heightCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:100];
    [redView addConstraint:heightCon];
    
    // 添加右边约束
    NSLayoutConstraint* rightCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
    [self.view addConstraint:rightCon];
    
    // 添加底部约束
    NSLayoutConstraint* bottomCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20];
    [self.view addConstraint:bottomCon];
}


- (void)test2{

    UIView* redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    
    UIView* blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blueView];
    
    // 添加左边约束
    NSLayoutConstraint* redView_leftCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
    [self.view addConstraint:redView_leftCon];
    
    // 添加顶部约束
    NSLayoutConstraint* redView_topCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100];
    [self.view addConstraint:redView_topCon];
    
    // 添加右边约束
    NSLayoutConstraint* redView_rightCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:blueView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-30];
    [self.view addConstraint:redView_rightCon];
    
    // 添加宽度约束
    NSLayoutConstraint* redView_widthCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:blueView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.view addConstraint:redView_widthCon];
    
    // 添加高度约束
    NSLayoutConstraint* redView_heightCon = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50];
    [redView addConstraint:redView_heightCon];
    
    
    // ------ 蓝色 blueView 添加约束
    
    // 添加右边约束
    NSLayoutConstraint* blueView_rightCon = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
    [self.view addConstraint:blueView_rightCon];
    
    // 添加顶部约束
    NSLayoutConstraint* blueView_topCon = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:blueView_topCon];
    
    // 添加高度约束
    NSLayoutConstraint* blueView_heightCon = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.view addConstraint:blueView_heightCon];
}

@end









