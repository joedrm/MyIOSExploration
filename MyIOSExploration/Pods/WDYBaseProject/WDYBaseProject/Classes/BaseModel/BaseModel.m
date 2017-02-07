//
//  BaseModel.m
//  Pods
//
//  Created by fang wang on 17/1/10.
//
//

#import "BaseModel.h"
#import <MJExtension/MJExtension.h>
#import "FileCacheManager.h"

@implementation BaseModel

MJCodingImplementation;

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             @"desc":@"description",
             @"responseData" : @"data"
             };
}

+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)response {
    if ([response isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [self mj_objectArrayWithKeyValuesArray:response];
        return array;
    }
    return [NSMutableArray new];
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:dictionary];
    }
    return [[self alloc] init];
}

+ (void)setUpModelClassInArrayWithContainDict:(NSDictionary *)dict {
    if (dict.allKeys.count == 0) {
        return ;
    }
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return dict;
    }];
}

+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)response containDict:(NSDictionary *)dict {
    if (dict == nil) {
        dict = [NSMutableDictionary new];
    }
    [self setUpModelClassInArrayWithContainDict:dict];
    return [self modelArrayWithDictArray:response];
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary containDict:(NSDictionary *)dict {
    if (dict == nil) {
        dict = [NSMutableDictionary new];
    }
    [self setUpModelClassInArrayWithContainDict:dict];
    return [self modelWithDictionary:dictionary];
}

- (id)unarchiver {
    id obj = [FileCacheManager getObjectByFileName:[self.class description]];
    return obj;
}

- (void)archive {
    [FileCacheManager saveObject:self byFileName:[self.class description]];
}

- (void)remove {
    [FileCacheManager removeObjectByFileName:[self.class description]];
}


@end
