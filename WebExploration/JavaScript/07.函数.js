/**
 * Created by fangwang on 17/3/21.
 */

console.log('----------------------函数的定义---------------------------')
/**
 * 函数的第一种定义方式:
 *      function 指出这是一个函数定义
 *      abs 是函数的名称
 *      (x) 括号内列出函数的参数，多个参数以,分隔
 *      { ... } 之间的代码是函数体，可以包含若干语句，甚至可以没有任何语句
 *      一旦执行到 return 时，函数就执行完毕，并将结果返回
 *      JavaScript 的函数也是一个对象，abs()函数实际上是一个函数对象，而函数名 abs 可以视为指向该函数的变量
 * */
function abs1(x) {
    if (x >= 0){
        return x;
    }else {
        return -x;
    }
}

/**
 * 函数的第二种定义方式
 *      这种方式 function (x) { ... } 是一个匿名函数，它没有函数名
 *      这个匿名函数赋值给了变量 abs，所以，通过变量 abs 就可以调用该函数
 * */
var abs2 = function (x) {
    if (x >= 0){
        return x;
    }else {
        return -x;
    }
};

// 上述两种定义完全等价，注意第二种方式按照完整语法需要在函数体末尾加一个;，表示赋值语句结束

/**
 * 函数调用
 * */
abs1(100);
console.log(abs1(100));
abs2(-100);
console.log(abs2(-100));
// 传入的参数比定义的参数多或者少都没有问题
abs1(100, 'abc');
console.log(abs1(100, 'abc'));
abs1();

console.log('------------------arguments 关键字-------------------------------')

/**
 * 关键字arguments
 *      它只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数。
 *      arguments类似Array但它不是一个Array
 */
function foo(x) {
    // console.log(x);
    for (var i = 0; i < arguments.length; i ++){
        console.log(arguments[i]);
    }
}
foo(20, 30, 40, 40, 50); // 20, 30, 40, 50

// arguments 可以获得调用者传入的所有参数。也就是说，即使函数不定义任何参数，还是可以拿到参数的值
function abs3() {
    if (arguments.length === 0){
        return 0;
    }
    var x = arguments[0];
    return x >= 0 ? x : -x;
}
console.log(abs3());
console.log(abs3(100));
console.log(abs3(-100));

// arguments 最常用于判断传入参数的个数
function foo1(a, b, c) {
    // 接收 2~3 个参数，b 是可选参数，如果只传2个参数，b默认为 null：
    if (arguments.length === 2) {
        // 实际拿到的参数是a和b，c为undefined
        c = b; // 把b赋给c'
        b = null; // b变为默认值
    }
}
foo1(1, 2);


console.log('------------------rest参数 关键字-------------------------------')
/**
 * rest参数:
 *      为了获得额外的参数，如下例：获取除去 a, b 以外的参数
 *      rest参数只能写在最后，前面用...标识
 *      传入的参数先绑定a、b，多余的参数以数组形式交给变量rest，所以，不再需要arguments我们就获取了全部参数。
 *      如果传入的参数连正常定义的参数都没填满，也不要紧，rest参数会接收一个空数组（注意不是undefined）
 *      rest参数是ES6新标准
 */
function foo2(a, b, ...rest) {
    console.log(a);
    console.log(b);
    console.log(rest);
}
foo2(1, 2, 3, 4, 5, 6);
/** 打印结果：
 1
 2
 [ 3, 4, 5, 6 ]
 */









