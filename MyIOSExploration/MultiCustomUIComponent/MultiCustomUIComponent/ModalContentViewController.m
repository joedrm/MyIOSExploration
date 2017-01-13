//
//  ModalContentViewController.m
//  MultiCustomUIComponent
//
//  Created by fang wang on 17/1/13.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ModalContentViewController.h"

@interface ModalContentViewController ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;
@end

@implementation ModalContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.view.layer.cornerRadius = 6;
    
//    self.imageView = [[UIImageView alloc] init];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageView.clipsToBounds = YES;
//    self.imageView.layer.borderWidth = 2.0;
//    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.imageView.image = [UIImage imageNamed:@""];
//    [self.view addSubview:self.imageView];
//    
//    self.textLabel = [[UILabel alloc] init];
//    self.textLabel.numberOfLines = 0;
//    self.textLabel.text = @"如果你的浮层是以UIViewController的形式存在的，那么就可以通过modalViewController.contentViewController属性来显示出来。\n利用UIViewController的特点，你可以方便地管理复杂的UI状态，并且响应设备在不同状态下的布局。\n例如这个例子里，图片和文字的排版会随着设备的方向变化而变化，你可以试着旋转屏幕看看效果。" ;
//    [self.view addSubview:self.textLabel];
}


#pragma mark - <ModalPresentationContentViewProtocol>

- (CGSize)preferredContentSizeInModalPresentationVC:(ModalPresentationViewController *)controller limitSize:(CGSize)limitSize {
    // 高度无穷大表示不显示高度，则默认情况下会保证你的浮层高度不超过ModalPresentationViewController的高度减去contentViewMargins
    return CGSizeMake(CGRectGetWidth(controller.view.bounds) - 80, 300);
}

@end





