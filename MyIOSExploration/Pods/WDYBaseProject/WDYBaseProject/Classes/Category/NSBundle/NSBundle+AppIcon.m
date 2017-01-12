
#import "NSBundle+AppIcon.h"

@implementation NSBundle (AppIcon)

- (NSString*)appIconPath
{
    NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
    NSString* iconExtension = [iconFilename pathExtension] ;
    
    return [[NSBundle mainBundle] pathForResource:iconBasename ofType:iconExtension];
}

- (UIImage*)appIcon
{
    UIImage*appIcon = [[UIImage alloc] initWithContentsOfFile:[self appIconPath]] ;
    return appIcon;
}

@end
