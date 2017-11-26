
#include <stdio.h>
/*
include作用
    1> 拷贝右边文件路径下的所有内容到#include所在位置
    2> 自定义的用""，系统的用<>
    3> #include <stdio.h> 目的就是拷贝 printf 的声明
 */
int main(int argc, char const *argv[])
{
	
	printf("hello world\n");
	#include "abc.text"
	return 0;
}