//
//  CustomTextField.h
//  Pods
//
//  Created by fang wang on 16/12/29.
//
// 此文本框禁止复制，粘贴和选择功能

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomTextInputMode){
    CustomTextInputModeZh_Hans = 0,
    CustomTextInputModeEn_US,
    CustomTextFieldModeOther
};

@interface CustomTextField : UITextField

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

/**
 输入类型
 */
@property (nonatomic, assign,readonly)CustomTextInputMode inputMode;

/**
 占位符的颜色
 */
@property (nonatomic, strong)UIColor *placeholderColor;

/**
 占位符的字体
 */
@property (nonatomic, strong)UIFont *placeholderFont;

/**
 真实长度（不计算高亮部分）
 */
@property (nonatomic, assign)NSInteger trueLength;

/**
 设置最大长度
 @warning 此值必须大于零
 */
@property (nonatomic, assign)NSInteger maxLength;


@end
