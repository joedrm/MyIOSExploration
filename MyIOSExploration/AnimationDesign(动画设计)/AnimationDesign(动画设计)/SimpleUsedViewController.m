//
//  SimpleUsedViewController.m
//  AnimationDesign(动画设计)
//
//  Created by fang wang on 17/3/17.
//  Copyright © 2017年 animationDesign. All rights reserved.
//

#import "SimpleUsedViewController.h"
#import <WDYBaseProject/WDYCategory.h>

@interface SimpleUsedViewController ()
@property (nonatomic, strong) LOTAnimationView* animView;
@property (nonatomic, strong) UIButton* actionBtn;
@end

@implementation SimpleUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LOTAnimationView* animView = [LOTAnimationView animationNamed:@"BOOM01"];
    animView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:animView];
    self.animView = animView;
    [animView playWithCompletion:^(BOOL animationFinished) {
        
        NSLog(@"动画执行完毕。。。");
        
    }];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"开始动画" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blackColor]];
    btn.titleLabel.font = kFontWithSize(13);
    [btn addActionHandler:^{
        [self.animView play];
    }];
    [self.view addSubview:btn];
    self.actionBtn = btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews{
    
    self.animView.viewSize = CGSizeMake(kScreenWidth, kScreenHeight * 0.4);
    self.animView.center = self.view.center;
    
    self.actionBtn.frame = CGRectMake(0, 0, 80, 30);
    self.actionBtn.center = self.view.center;
    self.actionBtn.y = kScreenHeight - 100;
    
}

@end
