#include <stdio.h>

#include <stdio.h>
#include <stdlib.h>

void main()
{
    int num;
    int i = 0;

    printf("请输入一个数字:");
    scanf("%d", &num);

    while(num>0)
    {
        i = num % 10;//计算每一位上的数字

        printf("%d\n", i);//打印每一位数字

        num = num / 10;//实现位与位之间的遍历
    }

    system("pause");
}