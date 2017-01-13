//
//  MultiCustomUIComponentVC.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/13.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "MultiCustomUIComponentVC.h"
#import "ModalPresentationViewController.h"
#import "ModalContentViewController.h"

#define QMUIViewAnimationOptionsCurveOut (7<<16)
#define QMUIViewAnimationOptionsCurveIn (8<<16)

@interface MultiCustomUIComponentVC ()
@property (nonatomic, strong) ModalPresentationViewController *myModalViewController;
@end

@implementation MultiCustomUIComponentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 自定义显示 和 隐藏动画
- (void)handleLayoutBlockAndAnimation {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"hello world!";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, contentView.frame.size.width, 50);
    label.center = CGPointMake(contentView.center.x, contentView.center.y - 20);
    [contentView addSubview:label];
    
    UITextField* textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(0, 0, contentView.frame.size.width, 30);
    textField.center = CGPointMake(contentView.center.x, contentView.center.y + 40);
    [contentView addSubview:textField];
    
    ModalPresentationViewController *modalViewController = [[ModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
//    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
//        CGFloat contentViewX = (containerBounds.origin.x - contentView.frame.origin.x)*0.5;
//        CGFloat contentViewY = (containerBounds.origin.y - contentView.frame.origin.y)*0.5;
//        contentView.frame = CGRectMake(100,
//                                       100,
//                                       (CGRectGetWidth(containerBounds)-CGRectGetWidth(contentView.frame))*0.5,
//                                       CGRectGetHeight(containerBounds) - 20 - CGRectGetHeight(contentView.frame));
//    };
    
    modalViewController.showingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewFrame, void(^completion)(BOOL finished)) {
//        CGFloat contentViewX = (containerBounds.origin.x - contentView.frame.origin.x)*0.5;
//        CGFloat contentViewY = (containerBounds.origin.y - contentView.frame.origin.y)*0.5;
//        CGFloat contentViewW = contentView.frame.size.width;
//        CGFloat contentViewH = contentView.frame.size.height;
//        contentView.frame = CGRectMake(100, 100, contentViewW, contentViewH);
        dimmingView.alpha = 0;
        [UIView animateWithDuration:.3 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 1;
            contentView.frame = contentViewFrame;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    
    modalViewController.hidingAnimation = ^(UIView *dimmingView, CGRect containerBounds, CGFloat keyboardHeight, void(^completion)(BOOL finished)) {
        [UIView animateWithDuration:.3 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
            dimmingView.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 记住一定要在适当的时机调用completion()
            if (completion) {
                completion(finished);
            }
        }];
    };
    [modalViewController showWithAnimated:YES completion:nil];
}


- (void)customDimmingView{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    
    UIImageView* imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"name01.jpeg"];
    
    ModalPresentationViewController *modalViewController = [[ModalPresentationViewController alloc] init];
    modalViewController.dimmingView = imageV;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

// 内容是控制器的时候
- (void)testContentViewController{
    
    ModalContentViewController* vc = [[ModalContentViewController alloc] init];
    ModalPresentationViewController *modalViewController = [[ModalPresentationViewController alloc] init];
    modalViewController.contentViewController = vc;
    modalViewController.maximumContentViewWidth = CGFLOAT_MAX;
    [modalViewController showWithAnimated:YES completion:nil];
}

// 弹出动画，文本框键盘处理
- (void)testModalViewController{

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = @"hello world!";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, contentView.frame.size.width, 50);
    label.center = CGPointMake(contentView.center.x, contentView.center.y - 20);
    [contentView addSubview:label];
    
    UITextField* textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(0, 0, contentView.frame.size.width, 30);
    textField.center = CGPointMake(contentView.center.x, contentView.center.y + 40);
    [contentView addSubview:textField];
    
    // 以Window方式弹出
    ModalPresentationViewController *modalViewController = [[ModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    //    modalViewController.maximumContentViewWidth = CGFLOAT_MAX;
    [modalViewController showWithAnimated:YES completion:nil];
    //    [self presentViewController:modalViewController animated:NO completion:nil];
    
    //    if (self.myModalViewController) {
    //        [self.myModalViewController hideInView:self.view animated:YES completion:nil];
    //    }
    //
    //    self.myModalViewController = [[ModalPresentationViewController alloc] init];
    //    self.myModalViewController.contentView = contentView;
    //    self.myModalViewController.animationStyle = ModalPresentationAnimationStylePopup;
    //    self.myModalViewController.view.frame = self.view.bounds;
    //    [self.myModalViewController showInView:self.view animated:YES completion:nil];
}


- (IBAction)modelPresentationVCOnWindow:(UIButton *)sender {
    
    [self handleLayoutBlockAndAnimation];
}



@end
