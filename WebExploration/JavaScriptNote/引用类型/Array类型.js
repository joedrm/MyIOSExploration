/**
 * Created by fangwang on 17/4/1.
 */


/**
 * 创建Array
 * */
var colors1 = new Array();
var colors2 = ["red", "blue", "green"];
var colors3 = new Array(20); // 创建长度为 20 的数组
var names = new Array("joy");// 创建一个包含一项，即字符串"Greg"的数组
var colors4 = Array(3);
var colors5 = Array("Greg");
var colors6 = [];  // 创建一个空数组

/**
 * 读取数组
 * */
var colors7 = ["red", "blue", "green"];
console.log(colors7[0]); // red
colors7[2] = "black";
console.log(colors7[2]); // black
colors7[3] = "brown";
// 如果设置某个值得索引超过了数组的长度，数组就会自动增加到该索引值加1的长度 colors7[3] 索引是，因此数组的长度就是4
console.log(colors7[3]);  // brown

/**
 * 数组的长度
 * */
var colors8 = ["red", "blue", "green"];
var names = [];
console.log(colors8.length); // 3
console.log(names.length); // 0
// 数组的length不是只读的，可以设置length属性，从数组的末尾 移除项 或 新增项
colors8.length = 2;
console.log(colors8); // [ 'red', 'blue' ]
console.log(colors8[2]); // undefined
// 利用length属性可以方便地在末尾添加新项
colors8[colors8.length] = "black"; // 在位置 3 添加 black 颜色
colors8[colors8.length] = "brown"; // 在位置 4 添加 brown 颜色
console.log(colors8); // [ 'red', 'blue', 'black', 'brown' ]
colors8[99] = "gray";
/**
 * 在 colors8 数组的位置99 插入了一个值，结果数组长度（length）就是100，
 * 而位置 3 到 位置 98 实际上都是不存在的，访问它们都将返回 undefined.
 * 数组 最多可以包含 4 292 967 295 个项
 * */
console.log(colors8.length); // 100


/**
 * 检测数组
 * */
var colors = ["red", "blue", "green"];
// ECMAScript 3 规定 instanceof 判断某个对象是不是数组
var isArray = colors instanceof Array;  // ECMAScript 3
console.log(isArray); // true
// ECMAScript 5 新增 判断某个值是不是数组
var isArr = Array.isArray(colors);
console.log(isArr); // true

var value = "hello"
var isArr = Array.isArray(value);
console.log(isArr); // false

/**
 * 转换方法
 * */
var colors = ["red", "blue", "green"];
console.log(colors.toString()); // red,blue,green
console.log(colors.valueOf()); // [ 'red', 'blue', 'green' ]
// join 方法
console.log(colors.join()); // red,blue,green
console.log(colors.join(",")); // red,blue,green
console.log(colors.join("|")); // red|blue|green


/**
 * 栈方法：push()、pop()
 * */
var colors = new Array();
var count = colors.push("red","green"); // 推入两项,返回数组的长度
console.log(count); // 2
var item = colors.pop();
console.log(item); // green  弹出最后一项
console.log(colors); // [ 'red' ]


/**
 * 队列方法：push()、shift()
 * */
var colors = new Array();
colors.push("red","green","blue");
var item = colors.shift(); // 取出第一项
console.log(item); // red
console.log(colors); // [ 'green', 'blue' ]
// unshift() 是在数组的前面添加项，push()在数组末端添加项
var count = colors.unshift("gray","yellow");
console.log(count); // 4
console.log(colors);  // [ 'gray', 'yellow', 'green', 'blue' ]

/**
 * 重排序方法：reverse()、sort()
 * */
var values = [1, 2, 3, 4, 5, 6];
// reverse() 反转数组的顺序
values.reverse();
console.log(values); // [ 6, 5, 4, 3, 2, 1 ]

var values = [1, 2, 3, 4, 5, 6];
values.sort();
// sort() 升序排列数组，
console.log(values); // [ 1, 2, 3, 4, 5, 6 ]
// 但是也有问题！
// 内部实现：sort() 会调用每个数组项的 toString()转型方法，然后比较得到字符串，以确定如何排序
// 即使是每一项是数值，比较的还是字符串
var values = [0, 1, 10, 15, 5];
values.sort();
// 字符串比较时，"10"在"5"前面
console.log(values); // [ 0, 1, 10, 15, 5 ]
// 解决
function compare(value1, value2) {
    if (value1 < value2){
        return -1;
    }else if (value1 > value2){
        return 1;
    }else {
        return 0;
    }
}
values.sort(compare);
console.log(values); // [ 0, 1, 5, 10, 15 ]

/**
 * 操作方法：concat()、slice()、splice()
 * */
// concat()：基于当前数组中的所有项创建一个新的数组，接收到的参数添加到这个新数组的末尾。
// 如果是数组，则会将数组的每一项添加到末尾
var colors = ["red", "green", "blue"];
var colors2 = colors.concat("yellow", ["black","brown"]);
console.log(colors); // [ 'red', 'green', 'blue' ]
console.log(colors2); // [ 'red', 'green', 'blue', 'yellow', 'black', 'brown' ]

// slice()
var colors = ["red", "green", "blue", "yellow", "purple"];
// 从位置 1 到数组的 末尾 截取生成新的数组
var colors1 = colors.slice(1);
// 从位置 1 到位置 4 截取 生成新的数组
var colors2 = colors.slice(1,4);
console.log(colors1); // [ 'green', 'blue', 'yellow', 'purple' ]
console.log(colors2); // [ 'green', 'blue', 'yellow' ]
// 下面两种情况结果是一样的
var colors3 = colors.slice(-2,-1);
console.log(colors3); // [ 'yellow' ]
var colors4 = colors.slice(3, 4);
console.log(colors4); // [ 'yellow' ]

// splice()
// 删除：指定两个参数表示要删除第一项的位置和要删除的项数，如：splice(0,2)删除数组的前两项
var colors = ["red", "green", "blue"];
var removed = colors.splice(0, 1);
console.log(colors); // [ 'green', 'blue' ]
console.log(removed); // [ 'red' ]

// 插入：指定三个参数，起始位置、要删除的项数和要任意数量插入的项
// 下面的意思是：在 索引1的位置，删除0项，插入字符串"yellow", "orange"，返回空数组
removed = colors.splice(1, 0, "yellow", "orange");
console.log(colors); // [ 'green', 'yellow', 'orange', 'blue' ]
console.log(removed); // []

// 替换：向指定位置插入任意数量的项，且同时删除任意数量的项，
// 也是三个参数：起始位置、要删除的项数和要任意数量插入的项
removed = colors.splice(1,1,"red","purple");
console.log(colors); // [ 'green', 'red', 'purple', 'orange', 'blue' ]
console.log(removed); // [ 'yellow' ]


/**
 * 位置方法：indexOf()、lastIndexOf()
 * indexOf(): 数组的开头向后查找
 * lastIndexOf(): 数组的末尾向前查找，与 indexOf() 相反
 * IE9 支持
 * */
var numbers = [1, 2, 3, 4, 5, 4, 3, 2, 1];
console.log(numbers.indexOf(4)); // 3
console.log(numbers.lastIndexOf(4)); // 5


/**
 * 迭代方法：
 * */
// every() 对数组中的每一项给定函数，函数的每一项返回ture，则返回true
var numbers = [1, 2, 3, 4, 5, 4, 3, 2, 1];
var everyResult = numbers.every(function (item, index, array) {
    return (item > 2);
});
console.log(everyResult); // false

// some() 对数组中的每一项给定函数，函数的任意一项返回ture，则返回true
var someResult = numbers.some(function (item, index, array) {
    return (item > 2);
});
console.log(someResult); // true

// filter() 对数组中的每一项给定函数，返回该函数会返回true的项组成的新数组
var filterResult = numbers.filter(function (item, index, array) {
    return (item > 2);
});
console.log(filterResult); // [ 3, 4, 5, 4, 3 ]

// map() 对数组中的每一项给定函数，返回每次函数调用结果组成的数组
var mapResult = numbers.map(function (item, index, array) {
    return (item * 2);
});
console.log(mapResult); // [ 2, 4, 6, 8, 10, 8, 6, 4, 2 ]

// forEach() 没有返回值，和 for 循环迭代数组一样
var forEachResult = numbers.forEach(function (item, index, array) {

});
console.log(forEachResult); // [ 2, 4, 6, 8, 10, 8, 6, 4, 2 ]


/**
 * 缩小方法：reduce()、reduceRight()
 * reduce(): 从数组的第一项开始遍历到最后
 * reduceRight()：和reduce()相反
 * */
var values = [1, 2, 3, 4, 5];
/***
 * prev: 前一个值
 * cur: 当前值
 * index: 项的索引
 * array: 数组对象
 */
var sum = values.reduce(function (prev, cur, index, array) {
    // 第一次执行回调函数：prev=1，cur=2
    // 第二次：prev=3(1加2的结果)，cur=3
    return prev + cur;
});
console.log(sum);  // 15

