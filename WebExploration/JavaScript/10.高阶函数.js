/**
 * Created by fangwang on 17/3/21.
 */

/**
 * 高阶函数:
 *      JavaScript的函数其实都指向某个变量。既然变量可以指向函数，函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。
 * */
// 编写高阶函数，就是让函数的参数能够接收别的函数。
function add(x, y, fun) {
    return fun(x) + fun(y);
}
var result = add(-5, 6, Math.abs);
console.log(result); // 11
