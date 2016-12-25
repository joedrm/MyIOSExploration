//
//  WheelView.m
//  CALayer及核心动画
//
//  Created by wdy on 2016/12/20.
//  Copyright © 2016年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "WheelView.h"
#import "WheelButton.h"

#define angleToRad(angle)  ((angle) / 180 * M_PI)

@interface WheelView ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *wheelImageView;
@property(nonatomic, strong) UIButton* selectedBtn;
@property(nonatomic, strong) CADisplayLink* displayLink;
@end

@implementation WheelView

+ (instancetype)wheelView{
    
    WheelView* wheelV = [[WheelView alloc] init];
    return wheelV;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil] lastObject];
        [self createButtons];
    }
    return self;
}


+ (instancetype)wheelViewFromNib{

    return  [[[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    self.wheelImageView.userInteractionEnabled = YES;
    [self createButtons];
}

- (void)startRotation{
    
    // 添加定时器
    self.displayLink.paused = NO;
}

- (void)stop{
    
    self.displayLink.paused = YES;
}

- (void)fireAnim{
    
    self.wheelImageView.transform = CGAffineTransformRotate(self.wheelImageView.transform, M_PI / 300.0);
}

// 不能使用核心动画，因为在旋转时按钮无法选中，需要做真实的旋转
- (void)coreAnim{
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI*4);
    anim.duration = 0.5;
    anim.repeatCount = 4;
    anim.delegate = self;
    [self.wheelImageView.layer addAnimation:anim forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    // 动画结束时当前选中的按钮指向最上方
    // 让当前选中的按钮的父控件倒着转回去
    
    // 获取当前选中按钮旋转的角度
    CGAffineTransform transform = self.wheelImageView.transform;
    // 获取旋转的度数
    CGFloat angle = atan2(transform.b, transform.a);
    
    self.wheelImageView.transform = CGAffineTransformMakeRotation(-angle);
}


// 创建转盘12个按钮 和 按钮上的图标
- (void)createButtons{
    
    NSInteger count = 12;
    
    // 加载原始大图
    UIImage* oriImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage* oriSelectedImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    // 裁剪的尺寸
    CGFloat clipY = 0;
    CGFloat clipW = oriImage.size.width / count * [UIScreen mainScreen].scale;
    CGFloat clipH = oriImage.size.height * [UIScreen mainScreen].scale;
    
    CGFloat btnW = 65;
    CGFloat btnH = 143;
    CGFloat angle = 0;
    
    for (int i = 0; i < count; i ++) {
        WheelButton* btn = [WheelButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        // 裁剪大图
        CGFloat clipX = i * clipW;
        // CGImageCreateWithImageInRect 使用的像素的坐标，我们通常开发中使用的是点坐标，所以需要 *2 或者 *3才能得到
        CGImageRef imageRef = CGImageCreateWithImageInRect(oriImage.CGImage, CGRectMake(clipX, clipY, clipW, clipH));
        [btn setImage:[UIImage imageWithCGImage:imageRef] forState:UIControlStateNormal];
        
        CGImageRef imageSelectedRef = CGImageCreateWithImageInRect(oriSelectedImage.CGImage, CGRectMake(clipX, clipY, clipW, clipH));
        [btn setImage:[UIImage imageWithCGImage:imageSelectedRef] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(0, 0, btnW, btnH);
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        btn.transform = CGAffineTransformMakeRotation(angleToRad(angle));
        angle += 30;
        
        [self.wheelImageView addSubview:btn];
        if (i == 0) {
            [self clicked:btn];
        }
    }
}

- (void)clicked:(UIButton *)sender{

    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
}
- (IBAction)startChoose:(id)sender {
    
    //让转盘快速的旋转几圈,
    [self coreAnim];
    //动画结束时当前选中的按钮指向最上方
}



- (CADisplayLink *)displayLink{
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fireAnim)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}

@end





