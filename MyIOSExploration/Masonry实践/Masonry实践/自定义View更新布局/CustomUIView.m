//
//  CustomUIView.m
//  Masonry实践
//
//  Created by fang wang on 17/1/9.
//  Copyright © 2017年 com.LBE.Photo. All rights reserved.
//

#import "CustomUIView.h"

@interface CustomUIView ()
@property (nonatomic, strong) UIView* aView;
@end
@implementation CustomUIView

- (instancetype)init{

    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.aView];
    }
    return self;
}

-(void)setLeftWidth:(CGFloat)leftWidth
{
    _leftWidth = leftWidth;
    
    [self setNeedsUpdateConstraints];
}

-(void)setRightWidth:(CGFloat)rightWidth
{
    _rightWidth = rightWidth;
    
    [self setNeedsUpdateConstraints];
}


- (void)updateConstraints{

    if (self.leftWidth>100) {
        [self.aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(5);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (self.rightWidth>100) {
        [self.aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
    }
    
    [super updateConstraints];
}

- (UIView*)aView
{
    if (!_aView) {
        _aView = [[UIView alloc] init];
        _aView.backgroundColor = [UIColor redColor];
        [self addSubview:_aView];
    }
    return _aView;
}

@end

/*
 setNeedsLayout：告知页面需要更新，但是不会立刻开始更新。执行后会立刻调用layoutSubviews。
 layoutIfNeeded：告知页面布局立刻更新。所以一般都会和setNeedsLayout一起使用。如果希望立刻生成新的frame需要调用此方法，利用这点一般布局动画可以在更新布局后直接使用这个方法让动画生效。
 layoutSubviews：系统重写布局
 setNeedsUpdateConstraints：告知需要更新约束，但是不会立刻开始
 updateConstraintsIfNeeded：告知立刻更新约束
 updateConstraints：系统更新约束
 */
























