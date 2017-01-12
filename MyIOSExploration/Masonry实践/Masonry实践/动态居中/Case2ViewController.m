//
//  Case2ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/2.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case2ViewController.h"


static const CGFloat ImageSize = 40;

@interface Case2ViewController ()
@property (nonatomic, strong) NSArray* imageNameArr;
@property (strong, nonatomic) NSMutableArray *widthConstraints;
@property (nonatomic, strong) UIView* containerView;
@end

@implementation Case2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"动态居中";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageNameArr = @[@"mario",@"pikaqiu",@"duola.jpeg",@"huoyin.jpeg",@"huoyin.jpeg"];
    _widthConstraints = [NSMutableArray new];
    
    // 创建容器_containerView
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ImageSize);
        make.center.mas_equalTo(self.view);
    }];
    
    // 创建四张图片
    NSMutableArray* imageViewArr = [NSMutableArray array];
    for (int i = 0; i<_imageNameArr.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:self.imageNameArr[i]];
        [_containerView addSubview:imageView];
        [imageViewArr addObject:imageView];
    }
    
    // 给四张图片添加约束
    CGSize imageSize = CGSizeMake(ImageSize, ImageSize);
    UIView __block *lastView = nil;
    MASConstraint __block *widthConstraint = nil;
    [imageViewArr enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            widthConstraint = make.width.mas_equalTo(imageSize.width);
            make.height.mas_equalTo(imageSize.height);
            //左边约束
            make.left.equalTo(lastView ? lastView.mas_right : view.superview.mas_left);
            //垂直中心对齐
            make.centerY.equalTo(view.superview.mas_centerY);
            //设置最右边的imageView的右边与父view的最有对齐
            if (idx == imageViewArr.count - 1) {
                make.right.equalTo(view.superview.mas_right);
            }
            [_widthConstraints addObject:widthConstraint];
            lastView = view;
        }];
    }];
    
    // 控制显示和隐藏 的 UISwitch
    NSMutableArray* swArr = [NSMutableArray array];
    for (int i = 0; i < self.imageNameArr.count; i++) {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.tag = i;
        [sw setOn:YES];
        [self.view addSubview:sw];
        [sw addTarget:self action:@selector(showOrHideAction:) forControlEvents:UIControlEventTouchUpInside];
        [swArr addObject:sw];
    }
    
    // UISwitch添加约束
    UISwitch __block *lastView2 = nil;
    [swArr enumerateObjectsUsingBlock:^(UISwitch *sw, NSUInteger idx, BOOL * _Nonnull stop) {
        [sw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_containerView.mas_bottom).offset(100);
            make.left.equalTo(lastView2 ? lastView2.mas_right : sw.superview.mas_left).offset(20);
            lastView2 = sw;
        }];
    }];
}

- (void) showOrHideAction:(UISwitch *)sender {
    NSUInteger index = (NSUInteger) sender.tag;
    MASConstraint *width = _widthConstraints[index];
    
    if (sender.on) {
        width.equalTo(@(ImageSize));
    } else {
        width.equalTo(@0);
    }
    NSLog(@"_containerView.frame.size.width = %.2f", _containerView.frame.size.width);
}

@end




