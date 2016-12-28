
#import <UIKit/UIKit.h>

/** 用十六进制颜色生成UIColor */
@interface UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
