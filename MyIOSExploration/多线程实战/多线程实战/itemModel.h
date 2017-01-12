//
//  itemModel.h
//  多线程实战
//
//  Created by wangdongyang on 16/9/9.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface itemModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *icon;

+ (instancetype) itemWithDic:(NSDictionary*)dict;
@end
