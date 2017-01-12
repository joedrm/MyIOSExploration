
#import <Foundation/Foundation.h>

@interface NSObject (AppInfo)

+ (NSString *)version;

+ (NSInteger)build;

+ (NSString *)identifier;

+ (NSString *)currentLanguage;

+ (NSString *)deviceModel;

@end
