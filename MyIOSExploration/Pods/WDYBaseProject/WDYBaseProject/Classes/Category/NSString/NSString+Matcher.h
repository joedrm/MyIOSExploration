
//https://github.com/damienromito/NSString-Matcher

#import <Foundation/Foundation.h>

@interface NSString(Matcher)

- (NSArray *)matchWithRegex:(NSString *)regex;

- (NSString *)matchWithRegex:(NSString *)regex atIndex:(NSUInteger)index;

- (NSString *)firstMatchedGroupWithRegex:(NSString *)regex;

- (NSTextCheckingResult *)firstMatchedResultWithRegex:(NSString *)regex;

@end
