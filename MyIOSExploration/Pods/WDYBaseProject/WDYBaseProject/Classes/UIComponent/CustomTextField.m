//
//  CustomTextField.m
//  Pods
//
//  Created by fang wang on 16/12/29.
//
//

#import "CustomTextField.h"
@interface CustomTextField()
@property (nonatomic, assign)NSInteger true_length;
@end
@implementation CustomTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if(action==@selector(paste:))//禁止粘贴
        return NO;
    if(action==@selector(select:))// 禁止选择
        return NO;
    if(action==@selector(selectAll:))// 禁止全选
        return NO;
    return[super canPerformAction:action withSender:sender];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - 属性的GET和SET方法

- (CustomTextInputMode)inputMode{
    NSString *lang = [self.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])
        return CustomTextInputModeZh_Hans;
    else if ([lang isEqualToString:@"en-US"])
        return CustomTextInputModeEn_US;
    return CustomTextFieldModeOther;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}
- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}
- (NSInteger)trueLength{
    
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    if (!position)
        self.true_length = self.text.length;
    return self.true_length;
    
}
- (void)setMaxLength:(NSInteger)maxLength{
    if (maxLength>0&&_maxLength==0) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customTextFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self];
    }
    else if (maxLength<=0){
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
    _maxLength = maxLength;
}

#pragma mark - 方法

-(void)customTextFiledEditChanged:(NSNotification *)obj{
    CustomTextField *textField = (CustomTextField *)obj.object;
    if (textField.trueLength>textField.maxLength) {
        textField.text = [textField.text substringToIndex:textField.maxLength];
    }
}


@end
