/**
 * Created by fangwang on 17/3/21.
 */

// 变量: 变量名是大小写英文、数字、$和_的组合，且不能用数字开头。变量名也不能是JavaScript的关键字，如if、while等。申明一个变量用var语句，
// 变量本身类型不固定的语言称之为动态语言
var a; // 申明了变量a，此时a的值为undefined
var $b = 1; // 申明了变量$b，同时给$b赋值，此时$b的值为1
var s_007 = '007'; // s_007是一个字符串
var Answer = true; // Answer是一个布尔值true
var t = null; // t的值是null

// strict模式

// 使用var申明的变量则不是全局变量，它的范围被限制在该变量被申明的函数体内（函数的概念将稍后讲解），同名变量在不同的函数体内互不冲突。
// 为了修补JavaScript这一严重设计缺陷，ECMA在后续规范中推出了strict模式，在strict模式下运行的JavaScript代码，强制通过var申明变量，未使用var申明变量就使用的，将导致运行错误。
'use strict';
// 如果浏览器支持strict模式，
// 下面的代码将报ReferenceError错误:
// abc = 'hello world';
// alert(abc);


/*
* 全局变量:
*   全局变量是在函数体外部声明的变量
*   在函数体内部，但是没有用 var 声明的变量 也可以是全局变量，也称隐式的全局变量。
*   result 为全局变量，
* */
function test1() {
    result = 20
}
test1();
console.log(result);

var isFalse = new Boolean(false);
var ss = isFalse && true;
console.log('ss:'+ss);


// 引用类型的值
/**
 *
 * */
var obj1 = new Object();
var obj2 = obj1;
obj1.name = "nike";
console.log(obj2.name); // nike


// 没有块级作用域
/**
 * for 循环里面声明的变量 i 会被添加到当前的执行环境中，
 * */
for (var i = 0; i < 10; i++){
    console.log("i 的值："+i);
}
console.log(i) // 10


/**
 * 在搜索过程中，如果存在一个局部变量的定义，搜索就会停止，不再进入另一个变量对象
 * 换句话说，如果局部环境中存在着同名标识符，就不会使用位于父环境中的标识符
 * 当然，访问局部变量比访问全局变量快，因为不用向上搜索作用域链，
 * */
var color = "red"
function getColor() {
    var color = "blue"

    // 打印全局变量 color
    // console.log(window.color);

    return color;
}
console.log(getColor()); //blue


// 反例
/**
 * 第一个alert会弹 出”undefined”是因为myname被当做了函数的局部变量（尽管是之后声明的），
 * 所有的变量声明当被悬置到函数的顶部了。因此，为了避免这种混 乱，
 * 最好是预先声明你想使用的全部变量。
 * */
// myname = "global"; // 全局变量

function func() {
    console.log(myname); // "undefined"
    var myname = "local";
    console.log(myname); // "local"
}
func();














