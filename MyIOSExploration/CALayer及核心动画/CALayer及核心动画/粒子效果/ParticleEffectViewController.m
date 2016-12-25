//
//  ParticleEffectViewController.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "ParticleEffectViewController.h"
#import "ParticleView.h"

@interface ParticleEffectViewController ()
@property (weak, nonatomic) IBOutlet ParticleView *particleView;

@end

@implementation ParticleEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startDraw:(UIButton *)sender {
    [self.particleView startDraw];
}

- (IBAction)reDraw:(UIButton *)sender {
    [self.particleView reDraw];
    
}

@end
