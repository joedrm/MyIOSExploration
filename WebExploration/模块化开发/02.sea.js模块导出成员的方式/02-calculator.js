/*
 * @Author: iceStone
 * @Date:   2016-02-19 16:09:08
 * @Last Modified by:   iceStone
 * @Last Modified time: 2016-02-19 16:49:01
 */

// 定义一个模块，遵循Seajs的写法
define(function(require, exports, module) {

  // function add(a, b) {
  //   return parseFloat(a) + parseFloat(b);
  // }

  // function subtract(a, b) {
  //   return parseFloat(a) - parseFloat(b);
  // }

  // function multiply(a, b) {
  //   return parseFloat(a) * parseFloat(b);
  // }

  // function divide(a, b) {
  //   return parseFloat(a) / parseFloat(b);
  // }
  // // 暴露模块的公共成员
  // exports.add = add;
  // exports.subtract = subtract;
  // exports.multiply = multiply;
  // exports.divide = divide;

  // console.log(module.exports === exports);
  //
  // function Person(name, age, gender) {
  //   this.name = name;
  //   this.age = age;
  //   this.gender = gender;
  // }

  // Person.prototype.sayHi = function() {
  //   console.log('hi! I\'m a Coder, my name is ' + this.name);
  // };

  // // exports.Person = Person;
  // module.exports = Person;
  // 最终导出的以 module.exports
  // module.exports = { name: 'world' };
  // // 此时module.exports 指向的是一个新的地址
  // exports.name = 'hello';
  // // exports是module.exports的快捷方式，指向的任然是原本的地址

  // module.exports优先级第二
  module.exports = { name: 'hello' };
  console.log(module);
  // return 的优先级最高
  return { name: 'world' };
});
