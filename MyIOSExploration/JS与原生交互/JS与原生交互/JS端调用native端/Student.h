//
//  Student.h
//  hello
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol StudentJS <JSExport>

- (void)takePhoto;

@end

@interface Student : NSObject<StudentJS>
@property(nonatomic,strong)UIViewController * viewController;

@end
