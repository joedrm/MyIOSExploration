
#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

- (void)addActionHandler:(TouchedButtonBlock)touchHandler
{
    objc_setAssociatedObject(self, @selector(addActionHandler:), touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(blockActionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)blockActionTouched:(UIButton *)btn
{
    TouchedButtonBlock block = objc_getAssociatedObject(self, @selector(addActionHandler:));
    if (block)
    {
        block();
    }
}

@end

