
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define STR_LENGHT 40

int main(int argc, char const *argv[])
{
	
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

	printf("\n");

    //6.4.3 使用函数库连接字符串
	char str2[STR_LENGHT] = "To be or not to be";
	char str3[STR_LENGHT] = ", that is a question";
	if (STR_LENGHT > strlen(str2) + strlen(str3))
	{
		printf("%s\n", strcat(str2, str3));
	}else{
		printf("you can not put a quart into a pint pot");
	}

	// 6.4.4 比较字符串
	char str4[] = "This quick brown fox";
	char str5[] = "This quick black fox";
	// strcmp 在两个字符串中找到不同的字符吗来 比较字符码大小
	if (strcmp(str4, str5) < 0)
	{
		printf("str4 is less than str5");
	}
	// strncmp 比较两个字符串前10个字符的大小
	if (strncmp(str4, str5, 10) <= 0)
	{
		printf("\n%s\n%s", str4, str5);
	}else{
		printf("\n%s\n%s", str5, str4);
	}

	printf("\n");

	// 比较字符串例子
	// char word1[20];
	// char word2[20];
	// scanf("%19s", word1);
	// scanf("%19s", word2);

	// if (strcmp(word1, word2) == 0)
	// {
	// 	printf("you have entered identical words");
	// }else{
	// 	printf("\n%s precedes %s\n", strcmp(word1, word2) < 0 ? word1: word2, 
	// 		strcmp(word1, word2) < 0 ? word2: word1);
	// }

	printf("\n");

	// 6.4.5 搜索字符串中的一个字符
	char str6[] = "This quick brown fox";
	int c = 'q';
	char *pGo_char = NULL;
	// strchr:第一个参数是要搜索的字符串，第二个参数是要查找的字符串，
	// 返回值字符串中找到的第一个给定的字符地址，这是一个在内存中的地址，其类型是 *char 类型，
	// 要储存这个地址，需要创建字符地址变量
	// 如果没有找到给定的字符，函数就会返回 NULL, 相当于 0；表示这个指针没有指向任何对象
	pGo_char = strchr(str6, c);
	if (pGo_char != NULL)
	{
		printf("Character found was %c.", *pGo_char);
	}

	printf("\n");

	// 在字符串中查找子字符串
	// 返回找到的第一个字符串的位置的指针，找不到就返回NULL
	char str7[] = "This string contain the holy grail.";
	char str8[] = "the holy grail";
	char str9[] = "the holy grill";
	if (strstr(str7, str8) == NULL)	
	{	
		printf("%s was not found\n", str8);
	}else
		printf("\n%s was found in %s\n", str8, str7);

	if (strstr(str7, str9) == NULL)	
	{	
		printf("%s was not found\n", str9);
	}else
		printf("we should not get here");
	/* log 
	the holy grail was found in This string contain the holy grail.
	the holy grill was not found
	 */


	// 分析字符串
	char buffer[80];
	int i = 0;
	int num_letters = 0;
	int num_digits = 0;

	// if (fgets(buffer, sizeof(buffer), stdin) == NULL)
	// {
	// 	printf("Error reading input.");
	// 	return 1;
	// }else
		fgets(buffer, sizeof(buffer), stdin);

	while(buffer[i] != '\0'){
		if (isalpha(buffer[i]))
			num_letters++;
		if (isdigit(buffer[i++]))
			num_digits++;
	}
	printf("\n Your string contain %d lettes and %d digits.\n", num_letters, num_digits);
	/* log
	qwqw qwdd 23 dfrr 34 ffff
 	Your string contain 16 lettes and 4 digits.
	 */

	


	return 0;
}







