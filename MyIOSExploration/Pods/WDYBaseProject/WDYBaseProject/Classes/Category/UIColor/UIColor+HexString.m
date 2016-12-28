
#import "UIColor+HexString.h"

@implementation UIColor (HexString)

#pragma mark - 第一种
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
  NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
  
  // String should be 6 or 8 characters
  if ([cString length] < 6) return [UIColor redColor];
  
  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
  if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
  if ([cString length] != 6) return [UIColor redColor];
  // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [cString substringWithRange:range];
  
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  
  // Scan values
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  
  return [UIColor colorWithRed:((float) r / 255.0f)
                         green:((float) g / 255.0f)
                          blue:((float) b / 255.0f)
                         alpha:1.0f];
}

#pragma mark - 第二种
//+ (UIColor *)colorWithHexString:(NSString *)hexString {
//    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
//    CGFloat alpha, red, blue, green;
//    switch ([colorString length]) {
//        case 3: // #RGB
//            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 1];
//            green = [self colorComponentFrom: colorString start: 1 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
//            break;
//        case 4: // #ARGB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
//            red   = [self colorComponentFrom: colorString start: 1 length: 1];
//            green = [self colorComponentFrom: colorString start: 2 length: 1];
//            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
//            break;
//        case 6: // #RRGGBB
//            alpha = 1.0f;
//            red   = [self colorComponentFrom: colorString start: 0 length: 2];
//            green = [self colorComponentFrom: colorString start: 2 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
//            break;
//        case 8: // #AARRGGBB
//            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
//            red   = [self colorComponentFrom: colorString start: 2 length: 2];
//            green = [self colorComponentFrom: colorString start: 4 length: 2];
//            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
//            break;
//        default:
//            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
//            break;
//    }
//    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
//}
//
//+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
//    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
//    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
//    unsigned hexComponent;
//    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
//    return hexComponent / 255.0;
//}
//

@end
