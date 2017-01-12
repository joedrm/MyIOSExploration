//
//  NSArray+SafeArr.m
//  Runtime消息机制
//
//  Created by wangdongyang on 16/9/8.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "NSArray+SafeArr.h"
#import <objc/message.h>

@implementation NSArray (SafeArr)

+ (void)load
{
    [self swizzleInstanceMethodWithClass:NSClassFromString(@"__NSArrayI") originalSelector:@selector(objectAtIndex:) swizzledMethod:@selector(wdy_safeObjectAtIndex:)];
}

- (id)wdy_safeObjectAtIndex:(NSUInteger)index {
    
    if (self.count > index) {
        return [self wdy_safeObjectAtIndex:index];
    }else {
        
        NSLog(@"[%@ %@] index %lu beyond bounds [0 .. %lu]",
                 NSStringFromClass([self class]),
                 NSStringFromSelector(_cmd),
                 (unsigned long)index,
                 MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
}

+ (void)swizzleInstanceMethodWithClass:(Class)class
                      originalSelector:(SEL)originalSelector
                        swizzledMethod:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
