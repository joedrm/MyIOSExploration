/**
 * Created by fangwang on 17/4/1.
 */

/**
 * 声明函数
 * */
function sum1(num1, num2) {
    return num1 + num2;
}
// 或者
var sum2 = function (num1, num2) {
    return num1 + num2;
}
console.log(sum1(10,10));
console.log(sum2(20,20));
var anotherSum = sum1; // 不带括号的函数名，访问函数指针，而不是调用函数
sum1 = null
console.log(anotherSum(30,30));

/**
 * 没有重载
 * */
function addSomeNumber(num) {
    return num + 10;
};
function addSomeNumber(num) {
    return num + 200;
};
var result = addSomeNumber(100);
console.log(result); // 300

/**
 * 函数声明与函数表达式
 * */
// 函数声明
console.log(sum3(10, 10)); // 20
function sum3(num1, num2) {
    return num1 + num2;
}
// 函数表达式
// console.log(sum2(10, 10)); // 这里会发生错误
// var sum2 = function (num1, num2) {
//     return num1 + num2;
// }


/**
 * 作为值的函数
 * */
function callSomeFunction(someFunction, someArgument) {
    return someFunction(someArgument);
}
function add10(num) {
    return num + 10;
}
// 要访问函数的指针而不执行函数,必须去掉函数名后面的那对圆括号.
var result1 = callSomeFunction(add10, 10);
console.log(result1); // 20

function createComparisonFun(propertyName) {
    return function (obj1, obj2) {
        var value1 = obj1[propertyName];
        var value2 = obj2[propertyName];
        // console.log(value1);
        // console.log(value2);
        if (value1 < value2){
            return -1;
        }else if (value1 > value2){
            return 1;
        }else {
            return 0;
        }
    }
}
var data = [{name:"lily", age: 28},{name: "lucy", age: 29},{name: "Anna", age: 21}];
data.sort(createComparisonFun("name"));
console.log(data[0].name); // Anna

/**
 * 函数的内部属性:arguments.callee属性
 * */
// 阶乘函数
// 方法一
function factorial1(num) {
    if (num <= 1){
        return 1;
    }else {
        return num * factorial1(num - 1);
    }
}
// 方法二: arguments.callee 改写
// arguments.callee 属性: 是一个指针,执行拥有这个 arguments 对象的函数
function factorial2(num) {
    if (num <= 1){
        return 1;
    }else {
        return num * arguments.callee(num - 1);
    }
}
// 保存了函数 factorial2 的指针
var tureFactorial1 = factorial1;
factorial1 = function () {
    return 0;
}
console.log(tureFactorial1(5)); // 0
console.log(factorial1(5));  // 0

//-------- 对比方法一 ----------
var tureFactorial2 = factorial2;
factorial2 = function () {
    return 0;
}
console.log(tureFactorial2(5));// 120
console.log(factorial2(5)); // 0
// 对比发现: 使用arguments.callee解除耦合后,即使factorial2返回0,tureFactorial2仍能正常计算

/**
 * 函数的内部属性: this 属性
 * */
// window.color = "red";
var o = {color: "blue"};
function sayColor() {
    console.log(this.color);
}
// 此时在全局作用域, this 指向 window 对象
sayColor(); // red
o.sayColor = sayColor;
// this 引用的是 o 对象
o.sayColor(); // blue

/**
 * 函数的属性和方法
 * */
// length
function sayName(name) {
    console.log(name);
}
function sum(num1, num2) {
    return num1 + num2;
}
function sayHi() {
    console.log("hi");
}
console.log(sayName.length); // 1
console.log(sum.length); // 2
console.log(sayHi.length); // 0

// apply()  call()
// 这两个方法的用途都是在特定的作用域中调用函数，实际上等于设置函数体内this对象的值
function sum(num1, num2) {
    return num1 + num2;
}
function callSum1(num1, num2) {
    console.log(typeof this);
    return sum.apply(this, arguments);
}
function callSum2(num1, num2) {
    // console.log(this);
    return sum.apply(this, [num1, num2]);
}
console.log(callSum1(10, 10)); // 20
console.log(callSum2(10, 10)); // 20

// call():callSum()必须明确地传入每一个参数。结果与使用apply()没有什么不同。
// 至于是使用apply()还是call()，完全取决于你采取哪种给函数传递参数的方式最方便。
// 如果你打算直接传入arguments对象，或者包含函数中先接收到的也是一个数组，那么使用apply()肯定更方便；否则，选择call()可能更合适。
function sum(num1, num2){
    return num1 + num2;
}

function callSum(num1, num2){
    return sum.call(this, num1, num2);
}
console.log(callSum(10,10));   //20

// 传递参数并非apply()和call()真正的用武之地；它们真正强大的地方是能够扩充函数赖以运行的作用域
// window.color = "red";
var o = { color: "blue" };

function sayColor(){
    // alert(this.color);
}

sayColor();                //red
// sayColor.call(this);       //red
// sayColor.call(window);     //red
sayColor.call(o);          //blue


