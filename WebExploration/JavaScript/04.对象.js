/**
 * Created by fangwang on 17/3/21.
 */

/****************
对象声明：
 用一个 {...} 表示一个对象，键值对以 xxx: xxx 形式申明，用,隔开。如：name: 'lucy',
 注意，最后一个键值对不需要在末尾加,
 *****************/

var student = {

    name: 'lucy',
    birth: 1990,
    age: 22,
    school: 'No.2 Midlle School',
    weight: 60,
    score: null,
    // 如果属性名包含特殊字符，就必须用''括起来
    'hoby-more': 'Reading, Travel'
}

// 1 访问属性，访问属性是通过.操作符完成的，但这要求属性名必须是一个有效的变量名
var stu_name = student.name;
var stu_age = student.age;
var stu_school = student.school;
console.log('姓名：' + stu_name +'，年龄：' + stu_age + '，就读于：' + stu_school);

// 2 访问这个属性也无法使用.操作符，必须用['xxx']来访问， 在编码的时候属性名尽量使用标准的变量名
var hoby = student['hoby-more'];
console.log(hoby); // Reading, Travel

// 3 访问不存在的属性不报错，而是返回 undefined
// var profession = student.profession;
// console.log(profession);

// 4 由于 JavaScript 的对象是动态类型，你可以自由地给一个对象添加或删除属性
console.log(student.profession); // undefined
student.profession = 'English'; // 新增一个 profession 属性
console.log(student.profession); // English
delete student.profession;       // 删除 profession 属性
console.log(student.profession); // undefined

// 5 检测 student 是否拥有某一属性，可以用 in 操作符
var isHaveName = 'name' in student;
var isHaveGrade = 'grade' in student;
console.log(isHaveName, isHaveGrade); // true false

// 6 in  如果判断一个属性存在，该属性既包括自己的，也包括父类的
console.log('toString' in student); // true
// 因为 toString 定义在 object 对象中，而所有对象最终都会在原型链上指向 object，所以 student 也拥有 toString 属性

// 7 hasOwnProperty() 只能判断自身拥有的属性用
console.log(student.hasOwnProperty('name')); // true