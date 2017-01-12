//
//  CATransitionDemoVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CATransitionDemoVC.h"

@interface CATransitionDemoVC ()

@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation CATransitionDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"name01.jpeg"];
    imageView.frame = CGRectMake(0, 0, 200, 300);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}


static int _i = 1;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    _i ++;
//    
//    if (_i == 4) {
//        _i = 1;
//    }
//    
//    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"name0%d.jpeg", _i]];
//    
//    CATransition* anim = [CATransition animation];
//    anim.duration = 1;
//    anim.type = @"pageCurl";
//    anim.startProgress = 0.5;
//    
//    [self.imageView.layer addAnimation:anim forKey:nil];
    
    
    // 使用UIView来做转场动画
    [UIView transitionWithView:self.imageView duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _i ++;
        
        if (_i == 4) {
            _i = 1;
        }
        
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"name0%d.jpeg", _i]];
    } completion:^(BOOL finished) {
        
    }];
}

@end






