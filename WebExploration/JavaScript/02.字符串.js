/**
 * Created by fangwang on 17/3/21.
 */


// 用 '' 或 "" 括起来的字符表示

/*
* 1. 如果 ' 本身也是一个字符，那就可以用 "" 括起来，比如 "I'm OK" 包含的字符是 I，'，m，空格，O，K 这 6 个字符。
* 2. 如果字符串内部既包含'又包含"怎么办？可以用转义字符\来标识，比如：'I\'m \"OK\"!';
* */

// 多行字符串

// alert(`多行
// 字符串
// 测试`);

// 1.模板字符串
// 1.1. 要把多个字符串连接起来，可以用+号连接
// 1.2. 如果有很多变量需要连接，用+号就比较麻烦。ES6新增了一种模板字符串，表示方法和上面的多行字符串一样，但是它会自动替换字符串中的变量

var name = '小明';
var age = 20;
var  mesage = '你好，' + name + ', 你今年'+ age + '岁了';
// 也可以这样写
// var  mesage1 = `你好，${name}, 你今年${age}岁了!`;
// alert(mesage);

// 2.操作字符串
var s = 'hello world!';
s.length;

// 2.1 要获取字符串某个指定位置的字符，使用类似Array的下标操作，索引号从0开始
s[0]; // h
// 2.2 超出范围的索引不会报错，但一律返回undefined
s[13]; // undefined 超出范围的索引不会报错，但一律返回undefined
// 2.3 字符串是不可变的，如果对字符串的某个索引赋值，不会有任何错误，但是，也没有任何效果
var str = 'Test';
str[0] = 'x';
// alert(str);// str 仍然为'Test'


// 3.字符串常用方法
// 3.1 toUpperCase() 把一个字符串全部变为大写
var str1 = 'Hello';
str1.toUpperCase();

// 3.2 toLowerCase() 把一个字符串全部变为小写
str1.toLowerCase();

// 3.3 indexOf() 会搜索指定字符串出现的位置
var str2 = 'hello，world';
str2.indexOf('world'); // 6
str2.indexOf('World'); // 没有找到指定的子串，返回-1

console.log(str2.indexOf('world')) ;

// 3.4 substring 返回指定索引区间的子串
str2.substring(0,5); // 从索引0开始到5（不包括5），返回'hello'
str2.substring(6);   // 从索引7开始到结束，返回'world'

u(str2.substring(0,5)); // hello
console.log(str2.substring(6)); // world

