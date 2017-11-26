

/*

 	编写main函数
	链接：把项目中所有相关的.o文件、c语言函数库合并在一起生成可执行文件

	1. 函数定义放在 .c 文件，函数声明放在.h文件
	2. 如果要使用某个.c文件定义的函数，只需要 #include 这个 .c文件对应的.h文件
	3. .h文件的作用：被别人的拷贝，编译运行的时候不需要考虑.h文件
 */

#include <stdio.h>
#include "tool.h"
//#include "07.函数外部调用.c"

// int average(int a, int b){
// 	return (a + b)/2;
// }
// 
// int average();

int main() {
	
	int result = average(10, 20);

	int result2 = sum(10, 20);

	int result3  = minus(10, 20);

	printf("%d \n", result);
	printf("%d \n", result2);
	printf("%d \n", result3);

	return 0;
}




