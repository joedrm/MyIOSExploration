//
//  itemModel.m
//  多线程实战
//
//  Created by wangdongyang on 16/9/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "itemModel.h"

@implementation itemModel


+ (instancetype)itemWithDic:(NSDictionary *)dict
{
    itemModel* model = [[itemModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
