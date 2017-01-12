
#import <Foundation/Foundation.h>

@interface NSString (Contains)

/** 判断URL中是否包含中文 */
- (BOOL)isContainChinese;

/** 获取字符数量 */
- (int)wordsCount;

@end
