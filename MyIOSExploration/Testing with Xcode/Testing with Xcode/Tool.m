//
//  Tool.m
//  Testing with Xcode
//
//  Created by wdy on 2017/7/2.
//  Copyright © 2017年 wallan. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (int)add:(int)a b:(int)b{

    return a + b;
}

+ (int)devide:(int)a b:(int)b{

    if (b == 0) {
        return 0;
    }
    return a / b;
}

@end
