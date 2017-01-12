
#import <UIKit/UIKit.h>

typedef void (^TouchedButtonBlock)(void);

@interface UIButton (Block)

- (void)addActionHandler:(TouchedButtonBlock)touchHandler;

@end
