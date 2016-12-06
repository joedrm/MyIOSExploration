//
//  Case7ViewController.m
//  Masonry实践
//
//  Created by fang wang on 16/12/6.
//  Copyright © 2016年 com.LBE.Photo. All rights reserved.
//

#import "Case7ViewController.h"


static const CGFloat ITEM_SIZE = 40;
static const NSUInteger ITEM_COUNT = 4;

@interface Case7ViewController ()
@property (nonatomic, strong) UIView* containerView1;
@property (nonatomic, strong) UIView* containerView2;
@property (nonatomic, strong) NSArray* imageNames;
@end

@implementation Case7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"等间距";
    _imageNames = @[@"mario",@"pikaqiu",@"duola.jpeg",@"huoyin.jpeg",@"huoyin.jpeg"];
    
    _containerView1 = [[UIView alloc] init];
    _containerView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:_containerView1];
    [_containerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.center.mas_equalTo(self.view);
    }];
    
    _containerView2 = [[UIView alloc] init];
    _containerView2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_containerView2];
    [_containerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_containerView1.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
    }];
    [self initContainer1];
    [self initContainer2];
}

// 利用透明等宽度的SpaceView实现等间距
- (void)initContainer1 {
    UIView *lastSpaceView = [UIView new];
    lastSpaceView.backgroundColor = [UIColor blueColor];
    [_containerView1 addSubview:lastSpaceView];
    
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(_containerView1);
    }];
    
    for (NSUInteger i = 0; i < ITEM_COUNT; i++) {
        UIView *itemView = [self getItemViewWithIndex:i];
        [_containerView1 addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.equalTo(@(ITEM_SIZE));
            make.left.equalTo(lastSpaceView.mas_right);
            make.centerY.equalTo(_containerView1.mas_centerY);
        }];
        
        UIView *spaceView = [UIView new];
        spaceView.backgroundColor = [UIColor blueColor];
        [_containerView1 addSubview:spaceView];
        
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView.mas_right).with.priorityHigh(); // 降低优先级，防止宽度不够出现约束冲突
            make.top.and.bottom.equalTo(_containerView1);
            make.width.equalTo(lastSpaceView.mas_width);
        }];
        
        lastSpaceView = spaceView;
    }
    
    [lastSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView1.mas_right);
    }];
}

// 直接设置multiplier实现等间距
- (void)initContainer2 {
    for (NSUInteger i = 0; i < ITEM_COUNT; i++) {
        UIView *itemView = [self getItemViewWithIndex:i];
        itemView.backgroundColor = [UIColor blackColor];
        [_containerView2 addSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@(ITEM_SIZE));
            make.centerY.equalTo(_containerView2.mas_centerY);
            make.centerX.equalTo(_containerView2.mas_right).multipliedBy(((CGFloat)i + 1) / ((CGFloat)ITEM_COUNT + 1));
        }];
    }
}


- (UIView *)getItemViewWithIndex:(NSUInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageNames[index % _imageNames.count]]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

@end
