//
//  TestModel.m
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (instancetype)modelWithDict:(id)dict{

    TestModel* model = [[TestModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}


@end
