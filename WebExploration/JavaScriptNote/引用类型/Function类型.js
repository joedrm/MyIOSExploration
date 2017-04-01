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

