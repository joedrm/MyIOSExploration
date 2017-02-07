//
//  UIFont+TTF.h
//  Pods
//
//  Created by fang wang on 17/1/3.
//
//

#import <UIKit/UIKit.h>

@interface UIFont (TTF)
/**
 *  @brief  Obtain a UIFont from a TTF file. If the path to the font is not valid, an exception will be raised,
 *	assuming NS_BLOCK_ASSERTIONS has not been defined. If assertions are disabled, systemFontOfSize is returned.
 *
 *  @param path The path to the TTF file.
 *  @param size The size of the font.
 *
 *  @return A UIFont reference derived from the TrueType Font at the given path with the requested size.
 */

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size;

/**
 *  @brief  Convenience method that calls fontWithTTFAtPath:size: after creating a path from the provided URL.
 *
 *  @param URL  URL to the file (local only).
 *  @param size The size of the font.
 *
 *  @return A UIFont reference derived from the TrueType Font at the given path with the requested size.
 */

+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size;
@end
