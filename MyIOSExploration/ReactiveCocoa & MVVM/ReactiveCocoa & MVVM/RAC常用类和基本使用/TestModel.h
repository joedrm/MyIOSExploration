//
//  TestModel.h
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/3/5.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, copy) NSString* name;

@property (nonatomic, copy) NSString* icon;

+ (instancetype)modelWithDict:(id)dict;
@end
