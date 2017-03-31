/**
 * Created by fangwang on 17/3/21.
 */

/**
 * 变量作用域
 *      1. 如果一个变量在函数体内部申明，则该变量的作用域为整个函数体，在函数体外不可引用该变量
 *      2. 如果两个不同的函数各自申明了同一个变量，那么该变量只在各自的函数体内起作用。换句话说，不同函数内部的同名变量互相独立，互不影响
 *      3. 内部函数可以访问外部函数定义的变量，反过来则不行
 *      4. 如果内部函数定义了与外部函数重名的变量，则内部函数的变量将“屏蔽”外部函数的变量。
 */

'use strict';

function foo() {
    var x = 1;
    function bar() {
        var x = 'A';
        console.log('x in bar() = ' + x);
    }
    console.log('x in foo() = ' + x)
    bar();
}
foo();
/* 打印结果：
        x in foo() = 1
        x in bar() = A
  */

/**
 * 变量提升:
 *      JavaScript的函数定义有个特点，它会先扫描整个函数体的语句，把所有申明的变量“提升”到函数顶部
 * */
function foo1() {
    // 此处并没有报错，原因是变量y在稍后申明了
    // var y; // 提升变量y的申明
    var x = 'Hello，' + y;
    console.log(x);
    var y = 'Bob';
}
foo1(); // Hello，undefined
// JavaScript 引擎自动提升了变量 y 的声明，但不会提升变量 y 的赋值
// 在函数内部定义变量时，请严格遵守“在函数内部首先申明所有变量”这一规则。最常见的做法是用一个var申明函数内部用到的所有变量
function foo2() {
    var
        x = 1,  // x初始化为1
        y = x + 1,// y初始化为2
        z, i; // z和i为undefined
    for (i = 0; i < 100; i ++){
        // ..........
    }
}

/**
 * 全局作用域:
 *      不在任何函数内定义的变量就具有全局作用域,
 *      全局对象window，全局作用域的变量实际上被绑定到window的一个属性,
 *      JavaScript 实际上只有一个全局作用域。任何变量（函数也视为变量），如果没有在当前函数作用域中找到，就会继续往上查找，最后如果在全局作用域中也没有找到，则报ReferenceError错误。
 * */
function foo3() {
    return 'foo3'
}
foo3();
// window.foo3(); // 通过window.foo()调用


/**
 * 名字空间:
 *      原因：全局变量会绑定到window上，不同的JavaScript文件如果使用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，并且很难被发现
 *      解决：减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中
 * */
var MYAPP = {};
MYAPP.name = 'myapp';
MYAPP.version = 1.0;

MYAPP.foo = function () {
    return 'foo';
}
// 把自己的代码全部放入唯一的名字空间MYAPP中，会大大减少全局变量冲突的可能。

/**
 * 局部作用域:
 *      ES6引入了新的关键字let，用let替代var可以申明一个块级作用域的变量
 * */
function foo4() {
    var sum = 0;
    for (let i = 0; i < 100; i ++){
        sum += i;
    }
    i += 1;
}
foo4(); // ReferenceError: i is not defined

/**
 * 常量:
 *      ES6标准引入了新的关键字const来定义常量，const与let都具有块级作用域
 * */
const PI = 3.14;
