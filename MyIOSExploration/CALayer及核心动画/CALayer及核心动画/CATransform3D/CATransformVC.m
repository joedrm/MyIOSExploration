//
//  CATransformVC.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/18.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "CATransformVC.h"

@interface CATransformVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation CATransformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)start:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // 第一种写法
//        self.imageV.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
        
        // 第二种写法：或者通过KVC来快速实现旋转、平移、缩放
//        NSValue* value = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)];
//        [self.imageV.layer setValue:value forKey:@"transform"];
        
        // 第三种写法
        [self.imageV.layer setValue:@(100) forKeyPath:@"transform.translation.x"];
        
    }];
}


@end
