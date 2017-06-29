//
//  User.h
//  Realm学习和实践
//
//  Created by wdy on 2017/6/29.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Realm/Realm.h>

@class Car;
@interface User : RLMObject

@property NSString * username;
@property NSString * avatarUrl;
@property NSString * uid;
@end
