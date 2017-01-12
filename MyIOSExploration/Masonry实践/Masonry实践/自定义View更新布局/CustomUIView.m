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
    _leftWidth=leftWidth;
    
    [self setNeedsUpdateConstraints];
}

-(void)setRightWidth:(CGFloat)rightWidth
{
    _rightWidth=rightWidth;
    
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
