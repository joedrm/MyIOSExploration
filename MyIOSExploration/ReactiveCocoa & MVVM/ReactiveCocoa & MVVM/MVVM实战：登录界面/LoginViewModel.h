//
//  LoginViewModel.h
//  ReactiveCocoa & MVVM
//
//  Created by wdy on 2017/5/31.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic, copy) NSString* account;
@property (nonatomic, copy) NSString* pwd;

@property (nonatomic, strong, readonly) RACSignal* loginEnableSignal;

@property (nonatomic, strong) RACCommand* loginCommond;
@end
