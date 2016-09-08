//
//  NSObject+AssociateProperty3.m
//  三种方法实现Category添加属性
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "NSObject+AssociateProperty3.h"
#import <objc/runtime.h>

@implementation NSObject (AssociateProperty3)

static char const *phoneKey;

-(void)setPhone:(NSString *)phone{
    objc_setAssociatedObject(self,phoneKey,phone,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)phone{
    return objc_getAssociatedObject(self, phoneKey);
}

@end
