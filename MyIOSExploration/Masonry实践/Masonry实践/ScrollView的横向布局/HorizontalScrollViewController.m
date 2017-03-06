//
//  HorizontalScrollViewController.m
//  Masonry实践
//
//  Created by fang wang on 17/3/6.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "HorizontalScrollViewController.h"

@interface HorizontalScrollViewController ()

@end

@implementation HorizontalScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    // 最底部的 scrollView，横向滚动
    UIScrollView* backScrollView = [[UIScrollView alloc] init];
    backScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:backScrollView];
    
    // 头部的指示器 pageControll
    UIPageControl* pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [backScrollView addSubview:pageControl];

    // 当前存放 contentView 内容的 scrollView，竖向滚动
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.delaysContentTouches = NO;
    scrollView.pagingEnabled = YES;
    [backScrollView addSubview:scrollView];

    // 当前存放内容的 View
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:contentView];
    
    
    // 开始布局
    [backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backScrollView);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(pageControl.mas_bottom);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.right.equalTo(scrollView.mas_right);
        make.bottom.equalTo(scrollView.mas_bottom);
    }];
    
}



@end








