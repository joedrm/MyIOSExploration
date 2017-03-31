/**
 * Created by fangwang on 17/3/22.
 */

/**
 * 闭包的演变过程
 * */
// 对Array的求和
function sum(arr) {
    return arr.reduce(function (x, y) {
        return x + y;
    });
};
// 需求变了，不需要立刻求和，而是在后面的代码中，根据需要再计算
// 可以不返回求和的结果，而是返回求和的函数
function lazy_sum(arr) {
    var sum = function () {
        return arr.reduce(function (x, y) {
            return x + y;
        });
    };
    return sum;
}
// 调用 lazy_sum() 时，返回的并不是求和结果，而是求和函数
// 调用 lazy_sum() 时，每次调用都会返回一个新的函数，即使传入相同的参数
var f = lazy_sum([1, 2, 3, 4, 5]);
f();
console.log(f()); // 15


/**
 * 闭包：
 *      返回函数不要引用任何循环变量，或者后续会发生变化的变量
 *      引用循环变量怎么办？方法是再创建一个函数，用该函数的参数绑定循环变量当前的值，无论该循环变量后续如何更改，已绑定到函数参数的值不变
 * */
function count() {
    var arr = [];
    for (var i = 1; i <= 3; i ++){
        // 创建一个匿名函数并立刻执行
        arr.push((function (n) {
            return function () {
                return n * n;
            }
        })(i));
    }
    return arr;
}
var results = count();
var f1 = results[0];
var f2 = results[1];
var f3 = results[2];
console.log(f1, f2, f3); // [Function] [Function] [Function]

f1();
f2();
f3();
console.log(f1(), f2(), f3());// 1 4 9