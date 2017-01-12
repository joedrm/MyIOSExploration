
#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (instancetype)loadViewFromNib
{
    return [self loadViewFromNibWithName:NSStringFromClass([self class])];
}

+ (instancetype)loadViewFromNibWithName:(NSString *)nibName
{
    return [self loadViewFromNibWithName:nibName owner:nil];
}

+ (instancetype)loadViewFromNibWithName:(NSString *)nibName owner:(id)owner
{
    return [self loadViewFromNibWithName:nibName owner:owner bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadViewFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle
{
    UIView *result = nil;
    NSArray* elements = [bundle loadNibNamed:nibName owner:owner options:nil];
    for (id object in elements)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

@end
