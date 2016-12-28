
// https://github.com/croath/NSString-Pinyin

#import <Foundation/Foundation.h>

@interface NSString (Pinyin)

- (NSString*)pinyinWithPhoneticSymbol;

- (NSString*)pinyin;

- (NSArray*)pinyinArray;

- (NSString*)pinyinWithoutBlank;

- (NSArray*)pinyinInitialsArray;

- (NSString*)pinyinInitialsString;

@end
