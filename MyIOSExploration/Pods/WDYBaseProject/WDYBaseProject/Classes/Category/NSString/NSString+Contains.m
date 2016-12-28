
#import "NSString+Contains.h"

@implementation NSString (Contains)

- (BOOL)isContainChinese
{
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
        }
    }
    return NO;
}

/** 获取字符数量 */
- (int)wordsCount
{
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    
    for (i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c))
        {
            b++;
        }
        else if (isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
    }
    
    if (a == 0 && l == 0)
    {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

@end
