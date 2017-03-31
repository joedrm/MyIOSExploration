/**
 * Created by fangwang on 17/3/21.
 */

// Map

// 初始化Map需要一个二维数组
var m1 = new Map([['Michael', 95], ['Bob', 87], ['Tracy', 90]]);
var score = m1.get('Michael');
console.log(score); // 95

// 直接初始化一个空Map
var m2 = new Map();
m2.set('Adam', 66);
m2.set('Bob', 72);
m2.set('Tom', 55);
m2.set('Yuehan', 78);
m2.set('Lily', 90);
// 一个key只能对应一个value, 多次对一个key放入value，后面的值会把前面的值冲掉
m2.set('Lily', 88)
console.log(m2);
/**
 Map {
  'Adam' => 66,
  'Bob' => 72,
  'Tom' => 55,
  'Yuehan' => 78,
  'Lily' => 88
  }
 */

// Set
// Set和Map类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在Set中，没有重复的key
var s1 = new Set();
var s2 = new Set([1, 2, 3]);// 含1, 2, 3
console.log(s1, s2);

// 重复元素在Set中自动被过滤
var s3 = new Set([1, 2, 3, 3, '3']);
console.log(s3); // Set {1, 2, 3, "3"}

s3.add(4);
console.log(s3);
s3.delete(3);
console.log(s3);


