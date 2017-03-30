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

@property (nonatomic, strong) NSLayoutConstraint* blackView_leftCon;
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

    // xib 实现
    [self.blueView removeFromSuperview];
    
    // 代码实现
//    [self.blackView removeFromSuperview];
    self.blackView_leftCon.constant = 0.0f;
    [UIView animateWithDuration:2.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}


// 代码实现

- (void)test{

    UILabel* yellowView = [[UILabel alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    yellowView.translatesAutoresizingMaskIntoConstraints = NO;
    yellowView.text = @"A";
    yellowView.font = [UIFont systemFontOfSize:18];
    yellowView.textColor = [UIColor whiteColor];
    yellowView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:yellowView];
    self.yellowView = yellowView;
    
    
    UILabel* blackView = [[UILabel alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.text = @"B";
    blackView.font = [UIFont systemFontOfSize:18];
    blackView.textColor = [UIColor whiteColor];
    blackView.textAlignment = NSTextAlignmentCenter;
    blackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blackView];
    self.blackView = blackView;
    
    UILabel* grayView = [[UILabel alloc] init];
    grayView.backgroundColor = [UIColor redColor];
    grayView.text = @"C";
    grayView.font = [UIFont systemFontOfSize:18];
    grayView.textColor = [UIColor whiteColor];
    grayView.translatesAutoresizingMaskIntoConstraints = NO;
    grayView.textAlignment = NSTextAlignmentCenter;
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
    self.blackView_leftCon = blackView_leftCon;
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
