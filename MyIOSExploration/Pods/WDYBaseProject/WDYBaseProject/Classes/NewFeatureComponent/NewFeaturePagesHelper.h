//
//  NewFeaturePagesHelper.h
//  Pods
//
//  Created by fang wang on 17/1/9.
//
//

#import <Foundation/Foundation.h>

@interface NewFeaturePagesHelper : NSObject

+ (instancetype)shareInstance;

+(void)showIntroductoryPageView:(NSArray *)imageArray;
@end
