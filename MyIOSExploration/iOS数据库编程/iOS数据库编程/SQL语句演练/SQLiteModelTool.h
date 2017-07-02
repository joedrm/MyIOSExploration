//
//  SQLiteModelTool.h
//  iOS数据库编程
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 sqlite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

@interface SQLiteModelTool : NSObject


/**
 根据一个模型类, 创建数据库表
 
 @param cls 类名
 @param uid 用户唯一标识
 @return 是否创建成功
 */
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;


+ (void)saveModel:(id)model;

@end
