//
//  WDYGameModel.h
//  Youka
//
//  Created by wangdongyang on 16/7/26.
//  Copyright © 2016年 LeSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+ObjectMap.h"

@interface WDYGameModel : NSObject<ModelDelegate>

@property (nonatomic, assign) NSInteger gameId;

@property (nonatomic, copy) NSString *gameName;

@property (nonatomic, copy) NSString *localeId;

@property (nonatomic, copy) NSString *localeName;

@property (nonatomic, strong) NSArray *realms;
@end
