//
//  CustomToastContentView.h
//  MultiCustomUIComponent
//
//  Created by wdy on 2017/1/22.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <UIKit/UIKit.h>

// 自定义的 Toast ContentView，可根据需求自己定制
@interface CustomToastContentView : UIView
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong, readonly) UILabel *textLabel;
@property(nonatomic, strong, readonly) UILabel *detailTextLabel;

- (void)renderWithImage:(UIImage *)image text:(NSString *)text detailText:(NSString *)detailText;
@end
