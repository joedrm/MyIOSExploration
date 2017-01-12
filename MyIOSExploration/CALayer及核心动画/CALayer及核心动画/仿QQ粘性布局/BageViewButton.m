//
//  BageViewButton.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/25.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "BageViewButton.h"

@interface BageViewButton ()
@property (nonatomic, strong) UIView* smallView;
@property (nonatomic, weak) CAShapeLayer* shapLayer;
@end

@implementation BageViewButton


- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    [self setBackgroundColor:[UIColor redColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
    UIView* smallView = [[UIView alloc] initWithFrame:self.frame];
    smallView.layer.cornerRadius = self.layer.cornerRadius;
    smallView.backgroundColor = self.backgroundColor;
    [self.superview addSubview:smallView];
    [self.superview insertSubview:smallView belowSubview:self];
    self.smallView = smallView;
}

- (CGFloat)distanceBetweenTwoViewWithView1:(UIView*)smallV view2:(UIView*)bigV{
    
    CGFloat offX = bigV.center.x - smallV.center.x;
    CGFloat offY = bigV.center.y - smallV.center.y;
    // sqrt 开平方
    CGFloat distance = sqrt(offX*offX + offY*offY);
    return distance;
}

- (UIBezierPath*)pathWithSmallV:(UIView *)smallV bigV:(UIView*)bigV{
    
    CGFloat x1 = smallV.center.x;
    CGFloat y1 = smallV.center.y;
    
    CGFloat x2 = bigV.center.x;
    CGFloat y2 = bigV.center.y;
    
    CGFloat d = [self distanceBetweenTwoViewWithView1:smallV view2:bigV];
    
    if (d <= 0) {
        return nil;
    }
    
    
    CGFloat cosθ = (y2 - y1) / d;
    CGFloat sinθ = (x2 - x1) / d;
    
    CGFloat r1 = smallV.bounds.size.width * 0.5;
    CGFloat r2 = bigV.bounds.size.width * 0.5;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ, y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ, y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ, y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ, y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d * 0.5 * sinθ, pointA.y + d * 0.5 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d * 0.5 * sinθ, pointB.y + d * 0.5 * cosθ);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //AB
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    //BC(曲线)
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //CD
    [path addLineToPoint:pointD];
    //DA(曲线)
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

- (void)pan:(UIPanGestureRecognizer*)pan{

    CGPoint p = [pan translationInView:self];
    
    CGPoint center = self.center;
    center.x += p.x;
    center.y += p.y;
    self.center = center;
    
    [pan setTranslation:CGPointZero inView:self];
    
    CGFloat distance = [self distanceBetweenTwoViewWithView1:self.smallView view2:self];
    
   
    CGFloat smallR = self.bounds.size.width *0.5;
    smallR -= distance / 10.0;
    self.smallView.bounds = CGRectMake(0, 0, smallR*2, smallR*2);
    self.smallView.layer.cornerRadius = smallR;
    
    NSLog(@"%.2f", distance);
    
    UIBezierPath* path = [self pathWithSmallV:self.smallView bigV:self];
    if (self.smallView.hidden == NO) {
        self.shapLayer.path = path.CGPath;
    }
    
    if (distance > 200) {
        self.smallView.hidden = YES;
        [self.shapLayer removeFromSuperlayer];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (distance < 200) {
            [self.shapLayer removeFromSuperlayer];
            self.center = self.smallView.center;
            self.smallView.hidden = NO;
        }else{
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
            
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int i = 0 ; i < 8; i++) {
                UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"%d",i +1]];
                [imageArray addObject:image];
            }
            
            imageV.animationImages = imageArray;
            imageV.animationDuration = 1;
            [imageV startAnimating];
            
            [self addSubview:imageV];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    }
}

- (CAShapeLayer *)shapLayer{
    if (_shapLayer == nil) {
        CAShapeLayer *shapL = [CAShapeLayer layer];
        [self.superview.layer insertSublayer:shapL atIndex:0];
        shapL.fillColor = [UIColor redColor].CGColor;
        _shapLayer = shapL;
    }
    return _shapLayer;
}

// 去掉高亮效果
- (void)setHighlighted:(BOOL)highlighted{};

@end






