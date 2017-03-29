//
//  PriorityViewController.m
//  AutoLayoutPractice
//
//  Created by wdy on 2017/3/19.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "PriorityViewController.h"

@interface PriorityViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;


@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *grayView;
@end

@implementation PriorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    [self.blueView removeFromSuperview];
    [self.blackView removeFromSuperview];
}


// 代码实现

- (void)test{

    UIView* yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    yellowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:yellowView];
    self.yellowView = yellowView;
    
    
    UIView* blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blackView];
    self.blackView = blackView;
    
    UIView* grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor redColor];
    grayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:grayView];
    self.grayView = grayView;
    
    NSLayoutConstraint* yellowView_leftCon = [NSLayoutConstraint constraintWithItem:yellowView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];

    NSLayoutConstraint* yellowView_topCon = [NSLayoutConstraint constraintWithItem:yellowView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeTop multiplier:1.0 constant:100];
    
    
    NSLayoutConstraint* yellowView_widthCon = [NSLayoutConstraint constraintWithItem:yellowView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeWidth multiplier:0.0 constant:60];
    
    
    NSLayoutConstraint* yellowView_heightCon = [NSLayoutConstraint constraintWithItem:yellowView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:60];
    
    [self.view addConstraint:yellowView_leftCon];
    [self.view addConstraint:yellowView_topCon];
    [yellowView addConstraint:yellowView_widthCon];
    [yellowView addConstraint:yellowView_heightCon];
    
    
    // ------ blackView 添加约束
    
    // 添加左边约束
    NSLayoutConstraint* blackView_leftCon = [NSLayoutConstraint constraintWithItem:blackView
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:yellowView
                                                                         attribute:NSLayoutAttributeRight multiplier:1.0 constant:30];
    // 添加顶部约束
    NSLayoutConstraint* blackView_topCon = [NSLayoutConstraint constraintWithItem:blackView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:yellowView
                                                                        attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint* blackView_widthCon = [NSLayoutConstraint constraintWithItem:blackView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:yellowView
                                                                          attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    // 添加高度约束
    NSLayoutConstraint* blackView_heightCon = [NSLayoutConstraint constraintWithItem:blackView
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:yellowView
                                                                           attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.view addConstraint:blackView_leftCon];
    [self.view addConstraint:blackView_topCon];
    [self.view addConstraint:blackView_widthCon];
    [self.view addConstraint:blackView_heightCon];
    
    
    // ------ grayView 添加约束
    
    // 添加左边约束
    NSLayoutConstraint* gray_leftCon = [NSLayoutConstraint constraintWithItem:grayView attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:blackView
                                                                    attribute:NSLayoutAttributeRight multiplier:1.0 constant:30];
    
    NSLayoutConstraint* gray_leftCon2 = [NSLayoutConstraint constraintWithItem:grayView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:yellowView
                                                                     attribute:NSLayoutAttributeRight multiplier:1.0 constant:30];
    // 添加顶部约束
    NSLayoutConstraint* gray_topCon = [NSLayoutConstraint constraintWithItem:grayView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:yellowView
                                                                   attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint* gray_widthCon = [NSLayoutConstraint constraintWithItem:grayView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:yellowView
                                                                     attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

    // 添加高度约束
    NSLayoutConstraint* gray_heightCon = [NSLayoutConstraint constraintWithItem:grayView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:yellowView
                                                                      attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    gray_leftCon2.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:gray_leftCon];
    [self.view addConstraint:gray_leftCon2];
    [self.view addConstraint:gray_topCon];
    [self.view addConstraint:gray_widthCon];
    [self.view addConstraint:gray_heightCon];
}

@end
