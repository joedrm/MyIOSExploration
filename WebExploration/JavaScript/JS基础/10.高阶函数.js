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


/**
 * map() 函数：
 *      map()方法定义在JavaScript的Array中，我们调用Array的map()方法，传入我们自己的函数，就得到了一个新的Array
 *      其作用 把 f(x) 作用在 Array 的每一个元素并把结果生成一个新的 Array
 * */
function pow(x) {
    return x * x;
}

var arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
var mapArr = arr1.map(pow);
console.log(mapArr); // [ 1, 4, 9, 16, 25, 36, 49, 64, 81 ]

// 它把运算规则抽象了，因此，我们不但可以计算简单的f(x)=x2，还可以计算任意复杂的函数，比如，把Array的所有数字转为字符串
var strArr = arr1.map(String);
console.log(strArr); // [ '1', '2', '3', '4', '5', '6', '7', '8', '9' ]



/**
 * reduce() 函数：
 *      Array 的 reduce() 把一个函数作用在这个 Array 的 [x1, x2, x3...] 上，这个函数必须接收两个参数
 *      reduce()把结果继续和序列的下一个元素做累积计算，
 *      [x1, x2, x3, x4].reduce(f) = f(f(f(x1, x2), x3), x4)
 * */
// 对数组求和
var arr2 = [1, 3, 5, 7, 9];
var red = arr2.reduce(function (x, y) {
    return x + y;
});
console.log('red结果 = '+red); // 25

// [1, 3, 5, 7, 9]变换成整数13579
var red2 = arr2.reduce(function (x, y) {
    return x*10 + y;
})
console.log('red2结果 = '+red2); // 13579


/**
 * filter() 函数：
 *      用于把Array的某些元素过滤掉，然后返回剩下的元素
 *      filter() 把传入的函数依次作用于每个元素，然后根据返回值是 true 还是 false 决定保留还是丢弃该元素。
 * */
// 删掉偶数，只保留奇数
var arr3 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
var r = arr3.filter(function (x) {
    return x % 2 !== 0;
})
console.log('删掉偶数，只保留奇数：'+r); //1,3,5,7,9,11,13,15

// 把一个Array中的空字符串删掉
var arr4 = ['A', '', 'B', null, undefined, 'C', ''];
var r2 = arr4.filter(function (s) {
    return s && s.trim(); // 注意：IE9以下的版本没有trim()方法
})
console.log('把一个Array中的空字符串删掉：' + r2); //A,B,C

// filter()接收的回调函数，其实可以有多个参数
/***
 * 第一个参数，表示Array的某个元素
 * 第二个参数，表示元素的位置
 * 第三个参数，数组本身
 */
var arr5 = ['A', 'B', 'C']
var r3 = arr5.filter(function (element, index, self) {
    console.log(element);
    console.log(index);
    console.log(self);
    return true;
})
r3;

// 去除Array的重复元素
var arr6 = ['apple', 'banana', 'strawberry','pear', 'apple', 'orange', 'orange', 'strawberry']
var r4 = arr6.filter(function (element, index, self) {
    // indexOf() 总是返回第一个元素的位置, 后续的重复元素位置与indexOf返回的位置不相等，因此被filter滤掉了
   return  self.indexOf(element) === index;
});
console.log('去除Array的重复元素：' + r4); // apple,banana,strawberry,pear,orange


/**
 * sort() 函数：
 *      原理：Array 的 sort() 方法默认把所有元素先转换为 String 再排序
 *      sort()方法会直接对Array进行修改，它返回的结果仍是当前Array
 * */
// 以下直接调用 sort() 是有问题的
console.log(['Google', 'Apple', 'Microsoft'].sort()); // [ 'Apple', 'Google', 'Microsoft' ]
console.log(['Google', 'apple', 'Microsoft'].sort()); // [ 'Google', 'apple', 'Microsoft' ]
// Array的sort()方法默认把所有元素先转换为String再排序，结果'10'排在了'2'的前面，因为字符'1'比字符'2'的ASCII码小
console.log([10, 20, 1, 2].sort()); // [ 1, 10, 2, 20 ]

// 正确的做法
var arr7 = [10, 20, 1, 2];
var sortRes = arr7.sort(function (x, y) {
   if (x < y){
       return -1;
   }

   if (x > y){
       return 1;
   }
   return 0;
});
console.log(sortRes); // [ 1, 2, 10, 20 ]


// 对字符串排序，是按照ASCII的大小比较的，现在，我们提出排序应该忽略大小写，按照字母序排序
var arr7 = ['Google', 'apple', 'Microsoft'];
var r5 = arr7.sort(function (s1, s2){
    x1 = s1.toUpperCase();
    x2 = s2.toUpperCase();
    if (x1 < x2){
        return -1;
    }
    if (x1 > x2){
        return 1;
    }
    return 0;
});
console.log(r5); // [ 'apple', 'Google', 'Microsoft' ]