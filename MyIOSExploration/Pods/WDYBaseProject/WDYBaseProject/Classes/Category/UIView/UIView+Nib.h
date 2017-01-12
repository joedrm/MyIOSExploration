
#import <UIKit/UIKit.h>

@interface UIView (Nib)

+ (instancetype)loadViewFromNib;
+ (instancetype)loadViewFromNibWithName:(NSString *)nibName;
+ (instancetype)loadViewFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)loadViewFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;

@end
