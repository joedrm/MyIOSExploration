//
//  NSObject+AssociateProperty2.m
//  三种方法实现Category添加属性
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "NSObject+AssociateProperty2.h"
#import <UIKit/UIKit.h>


@implementation NSObject (AssociateProperty2)

static NSMutableDictionary *_dic;
static NSString *const nameID = @"nameID";

+ (void)load
{
    _dic = [NSMutableDictionary dictionary];
}


- (void)setAddress:(NSString *)address
{
    [_dic setObject:address forKey:nameID];
}

- (NSString *)address
{
    return [_dic objectForKey:nameID];
}

@end
