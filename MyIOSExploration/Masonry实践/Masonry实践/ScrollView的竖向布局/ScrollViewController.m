//
//  ScrollViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/27.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIScrollView* scrollV = [[UIScrollView alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollV];
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    // 添加一个容器的View
    /*
     创建一个视图容器 container 加到 scrollView 里
     container 的 edges 与 scrollView 相同，这个决定 container 的位置,与 scrollView 各边距为0
     container的width与height才是决定它的大小，而这个也决定了scrollView的contentSize
     在这里(伪代码)
     scrollView.contentSize = CGSizeMake(container.witdth + container.左边距 + container.右边距,
     container.height + container.顶部边距 + container.底部边距,)
     而container的width与scrollView相同，且左边距右边距为0，所以实际上横向不能滑动
     container的height由其子视图决定，具体分析下for循环里的代码
     */
    UIView* containerV = [[UIView alloc] init];
    [scrollV addSubview:containerV];
    [containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollV);
        make.width.equalTo(scrollV);
    }];
    
    //自上而下的顺序依次排列视图
    UIView *lastView = nil;
    for ( int i = 1 ; i <= 5 ; ++i ){
        UIView *subv = [UIView new];
        subv.backgroundColor = [self randomColor];
        //先加入到父视图，然后再设置其约束
        [containerV addSubview:subv];
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(containerV);//左右边距为0，相当于宽度与父视图与相等
            make.height.mas_equalTo(@(100+(i*20)));//设置高度
            if ( lastView ){
                make.top.mas_equalTo(lastView.mas_bottom);//设置排列在上一视图的下端
            }else{
                make.top.mas_equalTo(containerV.mas_top);//设置在顶端的子视图与父视图顶部边距相同
            }
        }];
        lastView = subv;
    }
    
    /*
     最后设置一下最底部的lastView与父视图container底部的距离，以此能自动计算出container的高度，
     也就算出了scrollView的contentSize,确定了能滑动的范围
     */
    [containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
}

- (UIColor*)randomColor{
    return [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                      saturation:( arc4random() % 128 / 256.0 ) + 0.5
                      brightness:( arc4random() % 128 / 256.0 ) + 0.5
                           alpha:1];
}

@end
