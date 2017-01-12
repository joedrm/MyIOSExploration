
#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;


- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;


+ (NSString *)reverseString:(NSString *)strSrc;

@end
