/**
 * Created by wdy on 2017/5/11.
 */


// 利用length来缩减或者清空数组
var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
arr.length = 5;
console.log(arr); // [ 1, 2, 3, 4, 5 ]


// 合并数组
var arr1 = [1, 2, 3];
var arr2 = [4, 5, 6];
var arr3 = arr1.concat(arr2);
console.log(arr3); // [ 1, 2, 3, 4, 5, 6 ]

// 改变this指向arr1, 调用push 并将arr2里面每一个元素当参数传过去
Array.prototype.push.apply(arr1, arr2)
console.log(arr1); //
