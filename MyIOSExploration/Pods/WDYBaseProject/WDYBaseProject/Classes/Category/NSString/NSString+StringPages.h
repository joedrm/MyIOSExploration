
#import <UIKit/UIKit.h>

@interface NSString (StringPages)
/**
 *  根据字符串进行分页
 *
 *  @param cache 需要进行分页的字符串
 *  @param font  你想显示的字体大小，这个要保持统一
 *  @param r     你想在多大的窗口显示
 *
 *  @return 返回一个数组，数组的元素是NSrange，根据NSRange来进行截取字符串
 */
- (NSArray *)getPagesOfString:(NSString *)cache withFont:(UIFont*)font inRect:(CGRect)r;

@end
