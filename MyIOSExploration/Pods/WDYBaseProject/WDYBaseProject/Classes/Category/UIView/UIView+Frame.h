//
//  UIView+Frame.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import <UIKit/UIKit.h>




@interface UIView (Frame)
/**
 控件起点
 */
@property (nonatomic) CGPoint viewOrigin;

/**
 控件大小
 */
@property (nonatomic) CGSize  viewSize;

/**
 控件起点x
 */
@property (nonatomic) CGFloat x;

/**
 控件起点Y
 */
@property (nonatomic) CGFloat y;

/**
 控件宽
 */
@property (nonatomic) CGFloat width;

/**
 控件高
 */
@property (nonatomic) CGFloat height;

/**
 控件顶部
 */
@property (nonatomic) CGFloat top;

/**
 控件底部
 */
@property (nonatomic) CGFloat bottom;

/**
 控件左边
 */
@property (nonatomic) CGFloat left;

/**
 控件右边
 */
@property (nonatomic) CGFloat right;

/**
 控件中心点X
 */
@property (nonatomic) CGFloat centerX;

/**
 控件中心点Y
 */
@property (nonatomic) CGFloat centerY;

/**
 控件左下
 */
@property(readonly) CGPoint BottomLeft ;

/**
 控件右下
 */
@property(readonly) CGPoint BottomRight ;

/**
 控件左上
 */
@property(readonly) CGPoint TopLeft ;
/**
 控件右上
 */
@property(readonly) CGPoint TopRight ;


/**
 屏幕中心点X
 */
@property (nonatomic, readonly) CGFloat middleX;

/**
 屏幕中心点Y
 */
@property (nonatomic, readonly) CGFloat middleY;

/**
 屏幕中心点
 */
@property (nonatomic, readonly) CGPoint middlePoint;


/**
 设置上边圆角
 */
- (void)setCornerOnTop:(CGFloat) conner;

/**
 设置下边圆角
 */
- (void)setCornerOnBottom:(CGFloat) conner;
/**
 设置左边圆角
 */
- (void)setCornerOnLeft:(CGFloat) conner;
/**
 设置右边圆角
 */
- (void)setCornerOnRight:(CGFloat) conner;

/**
 设置左上圆角
 */
- (void)setCornerOnTopLeft:(CGFloat) conner;

/**
 设置右上圆角
 */
- (void)setCornerOnTopRight:(CGFloat) conner;
/**
 设置左下圆角
 */
- (void)setCornerOnBottomLeft:(CGFloat) conner;
/**
 设置右下圆角
 */
- (void)setCornerOnBottomRight:(CGFloat) conner;


/**
 设置所有圆角
 */
- (void)setAllCorner:(CGFloat) conner;
@end
