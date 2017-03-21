/**
 * Created by fangwang on 17/3/21.
 */

// 1 for ... in 循环遍历
// 1.1 for ... in 遍历对象，把一个对象的所有属性依次循环出来
var person = {

    name : 'Jack',
    age: 25,
    city: 'shanghai'
};

for (var key in person){
    // console.log(key);
    // 要过滤掉对象继承的属性
    if (person.hasOwnProperty(key)){
        console.log(key);
    }
}

// 1.2 for ... in 遍历数组
var arr = ['A', 'B', 'C'];
for (var x in arr){
    console.log(x);
    console.log(arr[x]);
}

// 1.3 for ... in 循环历史遗留问题
arr.name = 'zhangsan';
for (var i in arr){
    console.log(i);  // 0, 1, 2, name
}
/*****
 遍历的实际上是对象的属性名称。一个 Array 数组实际上也是一个对象，它的每个元素的索引被视为一个属性。
 当我们手动给 Array 对象添加了额外的属性后，for ... in 循环将带来意想不到的意外效果，如上面的例子
 for ... in循环将把name包括在内，但Array的length属性却不包括在内
 */


// 2.1 for ... of 循环，只循环集合本身的元素
var arr2 = ['A', 'B', 'C'];
var s = new Set(['A', 'B', 'C']);
var m = new Map([['1', x], [2, 'y'], [3, 'z']]);

for (var x of arr2){
    console.log(x);
}

console.log('--------')
for (var x of s){
    console.log(x);
}

console.log('---------')
for (var x of m){
    console.log(x);
}
/** 打印结果：
 A
 B
 C
 A
 B
 C
 [ '1', '2' ]
 [ 2, 'y' ]
 [ 3, 'z' ]
 */

console.log('------------------------------------')

// 3 iterable 内置的 forEach 方法遍历
// forEach()方法是ES5.1标准引入的
var arr3 = ['A', 'B', 'C'];
arr3.forEach(function (element, index, array) {
    console.log(element);
    console.log(index);
    console.log(array);
})
/**
 A
 0
 [ 'A', 'B', 'C' ]
 B
 1
 [ 'A', 'B', 'C' ]
 C
 2
 [ 'A', 'B', 'C' ]
 */

console.log('------------forEach 遍历 Set------------------------')

// Set与Array类似，但Set没有索引，因此回调函数的前两个参数都是元素本身
s.forEach(function (element, sameElement, Set) {
    console.log(element);
})


console.log('-------------forEach 遍历 Map-----------------------')

// Map的回调函数参数依次为 value、key 和 map 本身
m.forEach(function (value, key, map) {
    console.log(key);
    console.log(value);
    console.log(map);
})



