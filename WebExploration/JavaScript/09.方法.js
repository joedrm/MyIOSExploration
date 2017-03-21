/**
 * Created by fangwang on 17/3/21.
 */

'use strict';

function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
};

var xiaoming = {

    name: '小明',
    birth: 1990,
    age: getAge
}

xiaoming.age;
xiaoming.age();
console.log(xiaoming.age); // [Function: age]
console.log(xiaoming.age()); // 27

// 以下三种调用结果是错误的：

// 错误一
// xiaoming.age();
// getAge(); // TypeError: Cannot read property 'birth' of undefined

// 错误二
// var fn = xiaoming.age; // 先拿到xiaoming的age函数
// fn(); // TypeError: Cannot read property 'birth' of undefined

// 错误三
// var xiaowen = {
//     name: '小明',
//     birth: 1990,
//     age: function () {
//         function getAgeFromBirth() {
//             var y = new Date().getFullYear();
//             return y - this.birth;
//         }
//         return getAgeFromBirth();
//     }
// };
// xiaowen.age();
// console.log('xiaowen.age方法：' + xiaowen.age()); // TypeError: Cannot read property 'birth' of undefined

// 错误三修复
var xiaowen = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};
xiaowen.age();
console.log('错误三修复 xiaowen.age方法：' + xiaowen.age());

/**
 * this 使用总结：
 *      1. this 是一个特殊变量，它始终指向当前对象，也就是xiaoming这个变量。所以，this.birth 可以拿到 xiaoming 的 birth 属性
 *      2. JavaScript 的函数内部如果调用了 this，那么这个this到底指向谁？答案是，视情况而定！
 *      3. 如果以对象的方法形式调用，比如xiaoming.age()，该函数的this指向被调用的对象，也就是xiaoming
 *      4. 如果单独调用函数，比如 getAge()，此时，该函数的 this 指向全局对象，也就是 window
 *      5. 要保证 this 指向正确，必须用 obj.xxx() 的形式调用！
 *      6. ECMA决定，在 strict 模式下让函数的 this 指向 undefined
 *      6. 错误三，原因是 this 指针只在 age 方法的函数内指向 xiaowen，在函数内部定义的函数，this 又指向 undefined 了！（在非strict模式下，它重新指向全局对象window！）
 * */



/**
 * apply
 *      要指定函数的this指向哪个对象，可以用函数本身的apply方法，它接收两个参数，第一个参数就是需要绑定的this变量，第二个参数是Array，表示函数本身的参数。
 * */
// 修改 上面的错误一
xiaoming.age();
var temp = getAge.apply(xiaoming, []);

console.log(temp); // 27


/**
 * 装饰器:
 *      利用 apply()，我们还可以动态改变函数的行为
 *
 * */





