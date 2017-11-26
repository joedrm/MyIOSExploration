//
//  ViewController.m
//  C 语言回顾
//
//  Created by wdy on 2017/9/3.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //6.4.1 使用函数库复制字符串
    char destination[] = "This string will be replaced";
    char source[] = "This string will be copied in part";
    size_t n = 26;
    strncpy(destination, source, n);
    printf("%s", strncpy(destination, source, n));
    
    printf("\n");
    
    //6.4.2 使用函数库确定字符串长度 strlen(<#const char *__s#>)
    char str1[] = "hello world!";
    size_t count = 0;
    count = strlen(str1);
    printf("%ld", count);

    //6.4.1 使用函数库连接字符串
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
