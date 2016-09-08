//
//  NSObject+AssociateProperty.m
//  三种方法实现Category添加属性
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "NSObject+AssociateProperty.h"
#import <UIKit/UIKit.h>

@implementation NSObject (AssociateProperty)

static NSString *_name = nil;

- (void)setName:(NSString *)name
{
    if (_name != name) {
        _name = [name copy];
    }
}


- (NSString*)name
{
    return _name;
}

@end
