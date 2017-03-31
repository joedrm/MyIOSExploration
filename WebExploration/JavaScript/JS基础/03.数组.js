/**
 * Created by fangwang on 17/3/21.
 */


/*
* 1. JavaScript的Array可以包含任意数据类型，并通过索引来访问每个元素
* */

// 1.1 length属性取得Array的长度
var arr = [1, 2, 3, 11, 10, 'Hello, World!'];
console.log(arr.length); // 6

// 1.2 直接给Array的length赋一个新的值会导致Array大小的变化
var arr1 = [1, 2, 3];
arr1.length = 6;
console.log(arr1); // [ 1, 2, 3, , ,  ]
arr1.length = 2;
console.log(arr1); // [ 1, 2 ]

// 1.3 通过索引把对应的元素修改为新的值
var arr2 = ['A', 'B', 'C'];
arr2[1] = 99;
console.log(arr2); // [ 'A', 99, 'C' ]

// 1.4 如果通过索引赋值时，索引超过了范围，同样会引起Array大小的变化
arr2[5] = 'ss';
console.log(arr2); // [ 'A', 99, 'C', , , 'ss' ]

/************************
注意：在编写代码时，不建议直接修改Array的大小，访问索引时要确保索引不会越界。
************************/


// 1.5 常用函数

// 1.5.1 通过indexOf()来搜索一个指定的元素的位置
var arr3 = [10, 20, '30', 'xyz'];
var index = arr3.indexOf(20); // 元素 20 的索引为 1
console.log(index);

// 1.5.2 slice() 截取Array的部分元素，然后返回一个新的Array
var arr4 = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
var sliceArr = arr4.slice(0, 3); // 从索引0开始，到索引3结束，但不包括索引3，结果: ['A', 'B', 'C']
var sliceArr2= arr4.slice(3); // 从索引3开始到结束，结果: : ['D', 'E', 'F', 'G']
console.log(sliceArr, sliceArr2);

// 1.5.2.1 注意到slice()的起止参数包括开始索引，不包括结束索引。
// 1.5.2.2 如果不给slice()传递任何参数，它就会从头到尾截取所有元素。利用这一点，我们可以很容易地复制一个Array
var aCopy = arr4.slice();
console.log(aCopy); // [ 'A', 'B', 'C', 'D', 'E', 'F', 'G' ]
console.log(aCopy === arr4); // false

// 1.5.3 push 和 pop
var arr5 = [1, 2];
arr5.push('A', 'B');
console.log(arr5); // [ 1, 2, 'A', 'B' ]
var pArr = arr5.pop();
console.log(pArr); // pop()返回'B'
console.log(arr5); // [ 1, 2, 'A' ]
arr5.pop();
arr5.pop();
arr5.pop();
console.log(arr5); // []
arr5.pop();  // 空数组继续pop不会报错，而是返回undefined
console.log(arr5);


// 1.5.4  unshift() 和 shift()
// unshift() 往Array的头部添加若干元素
// shift() 把Array的第一个元素删掉
var arr6 = [1, 2];
arr6.unshift('A', 'B'); // 返回Array新的长度: 4
console.log(arr6); // [ 'A', 'B', 1, 2 ]
arr6.shift(); // 'A'
console.log(arr6); // [ 'B', 1, 2 ]
arr6.shift(); arr6.shift(); arr6.shift();
console.log(arr6); // []
arr6.shift(); // 空数组继续shift不会报错，而是返回undefined
console.log(arr6);

// 1.5.5 sort()  对当前Array进行排序，它会直接修改当前Array的元素位置，直接调用时，按照默认顺序排序
var arr7 = ['C', 'A', 'F', 'G', 'E', 'B', 'D'];
arr7.sort();
console.log(arr7); // [ 'A', 'B', 'C', 'D', 'E', 'F', 'G' ]

// 1.5.6 reverse 反转数组元素
var arr8 = ['one', 'two', 'three'];
arr8.reverse();
console.log(arr8); // [ 'three', 'two', 'one' ]

// 1.5.7 splice 修改Array的“万能方法”，它可以从指定的索引开始删除若干元素，然后再从该位置添加若干元素
var arr9 = ['Apple', 'Microsoft', 'Yahoo', 'FaceBook', 'Oracle','Excite'];
// 从索引2开始删除3个元素,然后再添加两个元素:
var arr10 = arr9.splice(2, 3, 'Google','ABM');
console.log(arr10); // 返回删除的元素: [ 'Yahoo', 'FaceBook', 'Oracle' ]
console.log(arr9); // [ 'Apple', 'Microsoft', 'Google', 'ABM', 'Excite' ]

// 只删除,不添加:
arr9.splice(2,2)
console.log(arr9); // [ 'Apple', 'Microsoft', 'Excite' ]

// 只添加,不删除:
arr9.splice(2,0,'Google','FaceBook');
console.log(arr9);  // [ 'Apple', 'Microsoft', 'Google', 'FaceBook', 'Excite' ]

// 1.5.8 concat() 将两个Array连接起来，并返回一个新的Array, 没有修改当前Array，而是返回了一个新的Array
var arr11 = ['A', 'B', 'C'];
var added = arr11.concat([1, 2, 3]);
console.log(added); // [ 'A', 'B', 'C', 1, 2, 3 ]
console.log(arr11); // [ 'A', 'B', 'C' ]
// concat()方法可以接收任意个元素和Array，并且自动把Array拆开，然后全部添加到新的Array里
var added2 = arr11.concat(1, 2, [3, 4]);
console.log(added2); // [ 'A', 'B', 'C', 1, 2, 3, 4 ]

// 1.5.9 join()方法是一个非常实用的方法，它把当前Array的每个元素都用指定的字符串连接起来，然后返回连接后的字符串
var arr12 = ['A', 'B', 'C', 'D', 1, 2, 3];
var joinArr =  arr12.join('-');
console.log(joinArr); // A-B-C-D-1-2-3

// 1.6 多维数组: 数组的某个元素又是一个Array，则可以形成多维数组
var arr13 = [[1, 2, 3], [400, 500, 600], '-'];



