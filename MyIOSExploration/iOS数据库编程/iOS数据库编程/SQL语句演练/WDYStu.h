//
//  WDYStu.h
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

@interface WDYStu : NSObject <ModelProtocol>
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int stuNum;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float score;


@property (nonatomic, copy) NSString* address;
@end
