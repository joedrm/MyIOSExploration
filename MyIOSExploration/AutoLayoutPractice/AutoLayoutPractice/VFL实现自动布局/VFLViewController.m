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
    [self test3];
    [self test4];
    [self test5];
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

/*
 灵活间隔：@"H:|-[view1]-(>=0)-[view2]-|"   至少0点间隔，需要用‘()’括起来
 负数间隔：@"H:|-[view1]-(-10)-[view2]-|"   负数值得间隔需要加上括号
 优先级：@"H:|-(5@20)-[view1]-[view2]-|"    @符号表示优先级，@后面是设置优先级的值，这里优先级为20,最好还是使用括号括起来
 视图尺寸：@"H:[view1(120)]"  或者  @"H:[view1(==120)]"  圆括号指定 view1 的宽度为120
        @"H:[view1(>=50)]"  宽度至少为 50
        @"H:[view1(>=50,<=120)]"   宽度为 50 到 120 之间
        @"H:[view1(view2)]"  view1 的宽度 和 view2的宽度一致
        @"H:|-[view1(view2)]-[view2(view1)]-|"  也可以循环定义布局，不会报错，如 test3
 */

// 等分布局、循环定义约束 演示
- (void)test3{

    UILabel* redView = [[UILabel alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    
    UILabel* blueView = [[UILabel alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blueView];
    
    NSDictionary* dict = NSDictionaryOfVariableBindings(redView, blueView);
    NSDictionary* metrics = @{@"space" : @20};
    
    // 记住: 标准视图与视图间隔是8，视图到俯视图的间隔是20。
    // 所以如果想要 redView 和屏幕左边距离为0，需要加上"-0-"的间隔，redView 和 blueView也要加上"-0-"的间隔
    //    NSString* herFormat = @"H:|-[redView(blueView)]-[blueView(redView)]-|";
    
    NSString* herFormat = @"H:|-0-[redView(blueView)]-0-[blueView(redView)]-0-|";
    NSArray* arr = [NSLayoutConstraint constraintsWithVisualFormat:herFormat options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                           metrics:metrics views:dict];
    [self.view addConstraints:arr];
    
    // 垂直方向
    NSString* verFormat = @"V:|-180-[blueView(50)]";
    NSArray* arr1 = [NSLayoutConstraint constraintsWithVisualFormat:verFormat options:kNilOptions metrics:metrics views:dict];
    [self.view addConstraints:arr1];
}

// 最多（不超过）约束、至少（不少于）约束 演示
- (void)test4{
    
    UILabel* redView = [[UILabel alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redView];
    
    UILabel* greenView = [[UILabel alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:greenView];
    
    UILabel* blueView = [[UILabel alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:blueView];
    
    NSDictionary* dict = NSDictionaryOfVariableBindings(redView, greenView, blueView);
    NSDictionary* metrics = @{@"space" : @20};
    
    // redView 和 blueView 的宽度一致，并且宽度不超过80，而没有尺寸的 greenView 会占据剩下空间
    NSString* herFormat = @"H:|-0-[redView(<=80)]-0-[greenView]-0-[blueView(redView)]-0-|";
    NSArray* arr = [NSLayoutConstraint constraintsWithVisualFormat:herFormat options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                           metrics:metrics views:dict];
    [self.view addConstraints:arr];
    
    // 垂直方向
    NSString* verFormat = @"V:|-300-[blueView(50)]";
    NSArray* arr1 = [NSLayoutConstraint constraintsWithVisualFormat:verFormat options:kNilOptions metrics:metrics views:dict];
    [self.view addConstraints:arr1];
}

// 约束的优先级演示
- (void)test5{
    UILabel* redView = [[UILabel alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    redView.text = @"test5:  redView";
    [self.view addSubview:redView];
    
    
    UILabel* blueView = [[UILabel alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.translatesAutoresizingMaskIntoConstraints = NO;
    blueView.text = @"test5:  blueView";
    [self.view addSubview:blueView];
    
    NSDictionary* dict = NSDictionaryOfVariableBindings(redView, blueView);
    NSDictionary* metrics = @{@"space" : @20};
    
    // 最终 blueView == 250 获胜，redView 占据剩下的空间
    NSString* herFormat = @"H:|-0-[redView(==100@702)]-0-[blueView(==100@703)]-0-|";
    NSArray* arr = [NSLayoutConstraint constraintsWithVisualFormat:herFormat options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                           metrics:metrics views:dict];
    [self.view addConstraints:arr];
    
    // 垂直方向
    NSString* verFormat = @"V:|-400-[blueView(50)]";
    NSArray* arr1 = [NSLayoutConstraint constraintsWithVisualFormat:verFormat options:kNilOptions metrics:metrics views:dict];
    [self.view addConstraints:arr1];
}

// 匹配到父视图
void constraintToSuperView(UIView* view, float minimumSize, NSUInteger priority){
    if (!view || !view.superview) {
        return;
    }
    for (NSString* format in @[
                               @"H:|-(>=0@priority)-[view(==minimumSize@priority)]",
                               @"H:[view]-(>=0@priority)-|",
                               @"V:|-(>=0@priority)-[view(==minimumSize@priority)]",
                               @"V:[view]-(>=@priority)-|"
                               ]) {
        NSArray* constrains = [NSLayoutConstraint constraintsWithVisualFormat:format options:0
                                                                      metrics:@{@"priority":@(priority)}
                                                                        views:@{@"view":view}];
        [view.superview addConstraints:constrains];
    }
    
}

- (void)test6{

    
}

@end








