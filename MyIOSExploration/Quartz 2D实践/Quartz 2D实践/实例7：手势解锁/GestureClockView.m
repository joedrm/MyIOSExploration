//
//  GestureClockView.m
//  Quartz 2D实践
//
//  Created by wdy on 2016/12/11.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "GestureClockView.h"

@interface GestureClockView ()
@property (nonatomic, assign) CGPoint curP;
@property (nonatomic, strong) NSMutableArray* selectedArr;
@end

@implementation GestureClockView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI{

    for (int i = 0; i < 9; i++) {
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"]
             forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"]
             forState:UIControlStateSelected];
        
        [self addSubview:btn];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    
    for (UIButton* btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, curP) && (btn.selected == NO)) {
            btn.selected = YES;
            [self.selectedArr addObject:btn];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self];
    
    self.curP = curP;
    
    for (UIButton* btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, curP)&& (btn.selected == NO)) {
            btn.selected = YES;
            [self.selectedArr addObject:btn];
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSMutableString* str = [NSMutableString string];
    
    // 取消说有选中的按钮
    for (UIButton* btn in self.selectedArr) {
        btn.selected = NO;
        [str appendFormat:@"%ld", btn.tag];
    }
    
    // 查看按钮选中的顺序
    // 保存第一次输入的密码
    NSLog(@"-----%@------", str);
    NSString* pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    if (!pwd) {
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"pwd"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        if ([pwd isEqualToString:str]) {
            NSLog(@"密码正确");
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"手势输入正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            NSLog(@"密码错误");
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"手势输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
    
    // 清空路径
    [self.selectedArr removeAllObjects];
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect{
    
    if (self.selectedArr.count) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectedArr.count; i ++) {
            UIButton* btn = self.selectedArr[i];
            
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else{
                [path addLineToPoint:btn.center];
            }
        }
        
        [path addLineToPoint:self.curP];
        
        [path setLineWidth:10.0];
        [[UIColor redColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        [path stroke];
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 74;
    
    int colum = 3; //列数
    CGFloat margin = (self.bounds.size.width - wh*colum)/(colum + 1); // 间距
    int curC = 0;
    int curR = 0;
    
    for (int i = 0; i < self.subviews.count; i ++) {
        
        UIButton* btn = self.subviews[i];
        
        curC = i % colum;
        curR = i / colum;
        
        x = margin + (wh + margin) * curC;
        y = margin + (wh + margin) * curR;
        
        btn.frame = CGRectMake(x, y, wh, wh);
    }
}

- (NSMutableArray *)selectedArr{
    if (_selectedArr == nil) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

@end









