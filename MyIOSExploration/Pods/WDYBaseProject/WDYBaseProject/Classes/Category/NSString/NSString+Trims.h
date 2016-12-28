
#import <Foundation/Foundation.h>

@interface NSString (Trims)

/** 清除html标签 */
- (NSString *)stringByStrippingHTML;

/** 清除js脚本 */
- (NSString *)stringByRemovingScriptsAndStrippingHTML;

/** 去除空格 */
- (NSString *)trimmingWhitespace;

/** 去除空格与空行 */
- (NSString *)trimmingWhitespaceAndNewlines;

@end
