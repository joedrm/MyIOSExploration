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
     
     +(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
     view1: 要约束的控件（purpleView）
     attr1: 约束的类型（常量），就是要做怎么样的约束，大家可以进去看看都有什么常量（这里是NSLayoutAttributeLeft）
     relation: 与参照控件之间的关系（常量），包括等于、大于等于、小于等于（NSLayoutRelationEqual 是指等于）
     view2: 参照的控件（self.view）
     attr2: 约束的类型（常量），就是要做怎么样的约束，大家可以进去看看都有什么常量（这里是NSLayoutAttributeLeft）（NSLayoutAttributeLeft）
     multiplier: 乘数，就是多少倍（1.0）
     c: 常量，做好了上述的约束之后会加上这个常量（100）
     */
    NSLayoutConstraint* constraint = [NSLayoutConstraint
                                      constraintWithItem:nil
                                      attribute:nil
                                      relatedBy:nil
                                      toItem:nil
                                      attribute:nil
                                      multiplier:0
                                      constant:0];
}



@end
