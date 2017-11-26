//
//  main.c
//  HelloWorld
//
//  Created by wdy on 2017/9/2.
//  Copyright © 2017年 wdy. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "hello.h"

/*
 1.函数定义的格式：
 返回值类型 函数名(形参列表){
    函数体
 }
 
 2. 返回值：
 void 代表没有返回值
 如果不明确返回值类型，默认是int类型
 就算明确了返回值，也可以不返回任何值
 
 3.C 语言不允许函数重名
 
 4. 函数不能嵌套定义
 
 5. 函数可以重复声明，但是不能重复定义
 
 6. 如果有函数的声明，没有函数的定义
    1> 编译可以通过，因为编译器只会检测语法合不合理，并不会检测函数有没有定义
    2> 但是链接报错，因为链接的时候会检测函数是否定义
 
 
 
 */
int test(){

    printf("test\n");
    return 0;
}

/*
 C 语言不允许函数重名
int test(int a, int b){
    
    printf("test\n");
    return 0;
}
 */

int sum(int a, int b){

    return a + b;
}

int average(int num1, int num2){

    printf("%d \n", (num1 + num2)/2);
    return (num1 + num2)/2;
}


// 函数声明
void methedDecaler();
void methedDecaler();

int main() {
    
    
    // 等待输入一个字符
    //getchar();
    
    test();
    
    // 带参数的函数
    sum(10, 20);
    
    printf("%d \n", sum(10, 10));
    
    average(100, 200);
    
    // 也可以在这里声明
    void methedDecaler();
    methedDecaler();
    
    return 0;
}

// 函数定义
void methedDecaler(){

    printf("---------");
}
