//
//  TableTool.h
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableTool : NSObject

+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid;

@end
