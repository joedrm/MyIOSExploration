//
//  ViewController.m
//  FeatureGuideView(引导用户使用)
//
//  Created by wdy on 2016/10/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "FeatureGuideViewController.h"
#import "UIView+EAFeatureGuideView.h"
#import "EAFeatureItem.h"

@interface FeatureGuideViewController ()

@end

@implementation FeatureGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 80, 40)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 80, 40)];
    btn2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn2];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"item2(null)"];
    
    EAFeatureItem *itemLeft = [[EAFeatureItem alloc] initWithFocusView:btn focusCornerRadius:0 focusInsets:UIEdgeInsetsMake(-10, -10, 10, 10)];
    itemLeft.introduce = @"左上部的提示";
    itemLeft.buttonBackgroundImageName=@"bottom_bg";
    
    EAFeatureItem *itemMid = [[EAFeatureItem alloc] initWithFocusView:btn2 focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
    itemMid.introduce = @"右中部的提示";
    itemMid.buttonBackgroundImageName=@"bottom_bg";
    [self.navigationController.view showWithFeatureItems:@[itemLeft,itemMid] saveKeyName:@"item2" inVersion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
