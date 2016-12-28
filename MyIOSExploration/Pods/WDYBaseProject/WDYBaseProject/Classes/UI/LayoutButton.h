//
//  LayoutButton.h
//  Pods
//
//  Created by fang wang on 16/12/28.
//
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LayoutButtonStyle) {
    LayoutButtonStyleLeftImageRightTitle,
    LayoutButtonStyleLeftTitleRightImage,
    LayoutButtonStyleUpImageDownTitle,
    LayoutButtonStyleUpTitleDownImage
};

/// 重写layoutSubviews的方式实现布局，忽略imageEdgeInsets、titleEdgeInsets和contentEdgeInsets
@interface LayoutButton : UIButton

/// 布局方式
@property (nonatomic, assign) LayoutButtonStyle layoutStyle;
/// 图片和文字的间距，默认值8
@property (nonatomic, assign) CGFloat midSpacing;
/// 指定图片size
@property (nonatomic, assign) CGSize imageSize;

@end
