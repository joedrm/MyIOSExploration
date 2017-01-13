//
//  ViewController.m
//  三种方法实现Category添加属性
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+AssociateProperty.h"
#import "NSObject+AssociateProperty2.h"
#import "NSObject+AssociateProperty3.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 给分类添加属性的三种实践
    Person *p1 = [[Person alloc] init];
    p1.name = @"小明";
    p1.address = @"武汉";
    p1.phone = @"ada";
    
    NSLog(@"%@ %@ %@",p1.name, p1.address, p1.phone);
    
}
- (IBAction)modelPresentationVCOnWindow:(id)sender {
}

@end
