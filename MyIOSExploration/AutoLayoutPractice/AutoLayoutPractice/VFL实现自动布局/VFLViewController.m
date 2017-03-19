//
//  VFLViewController.m
//  AutoLayoutPractice
//
//  Created by fang wang on 17/3/15.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "VFLViewController.h"

@interface VFLViewController ()

@end

@implementation VFLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    http://www.cnblogs.com/wupei/p/4150626.html
//    https://github.com/coderyi/AutoLayoutDemo
    
    [self test1];
    [self test2];
}

- (void)test1{

    UIView* redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    // 禁止autoresizing自动转换为约束
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    // 水平方向
    NSString* herFormat = @"H:|-space-[redView]-space-|";
    NSDictionary* dict = @{@"redView" : redView};
    NSDictionary* metrics = @{@"space" : @20};
    NSArray* arr = [NSLayoutConstraint constraintsWithVisualFormat:herFormat options:kNilOptions metrics:metrics views:dict];
    [self.view addConstraints:arr];
    
    // 垂直方向
    NSString* verFormat = @"V:[redView(40)]-space-|";
    NSArray* arr1 = [NSLayoutConstraint constraintsWithVisualFormat:verFormat options:kNilOptions metrics:metrics views:dict];
    [self.view addConstraints:arr1];
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
    
    // 水平方向
//    NSDictionary* dict = @{@"redView" : redView,
//                            @"blueView": blueView};
    NSDictionary* dict = NSDictionaryOfVariableBindings(redView, blueView);
    NSDictionary* metrics = @{@"space" : @20};
    NSString* herFormat = @"H:|-space-[redView]-space-[blueView(==redView)]-space-|";
    NSArray* arr = [NSLayoutConstraint constraintsWithVisualFormat:herFormat
                                                           options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                           metrics:metrics views:dict];
    [self.view addConstraints:arr];
    
    // 垂直方向
    NSString* verFormat = @"V:|-100-[blueView(50)]";
    NSArray* arr1 = [NSLayoutConstraint constraintsWithVisualFormat:verFormat options:kNilOptions metrics:metrics views:dict];
    [self.view addConstraints:arr1];
}

@end








