/**
 * Created by fangwang on 17/4/20.
 */

var obj = {
    name: "joy",
}

// 反面示例
var property = "name";
var result = eval("obj." + property);
// alert(result);
console.log(result);

// 更好的
var property = "name";
// alert(obj[property]);


console.log("**********************************************************");

/**
 使用新的Function()构造就类似于eval()，应小心接近。这可能是一个强大的构造，但往往被误用。
 如果你绝对必须使用eval()，你 可以考虑使用new Function()代替。
 有一个小的潜在好处，因为在新Function()中作代码评估是在局部函数作用域中运行，所以代码中任何被评估的通过var 定义的变量都不会自动变成全局变量。
 另一种方法来阻止自动全局变量是封装eval()调用到一个即时函数中。
 * */
console.log(typeof un);    // "undefined"
console.log(typeof deux); // "undefined"
console.log(typeof trois); // "undefined"

var jsstring = "var un = 1; console.log(un);";
eval(jsstring); // logs "1"

jsstring = "var deux = 2; console.log(deux);";
new Function(jsstring)(); // logs "2"

jsstring = "var trois = 3; console.log(trois);";
(function () {
    eval(jsstring);
}()); // logs "3"

console.log(typeof un); // number
console.log(typeof deux); // "undefined"
console.log(typeof trois); // "undefined"


console.log("**********************************************************");
/***
 另一间eval()和Function构造不同的是eval()可以干扰作用域链，而Function()更安分守己些。
 不管你在哪里执行 Function()，它只看到全局作用域。所以其能很好的避免本地变量污染。
 在下面这个例子中，eval()可以访问和修改它外部作用域中的变量，这是 Function做不来的（注意到使用Function和new Function是相同的）。
 * */
(function () {
    var local = 1;
    eval("local = 3; console.log(local)"); // logs "3"
    console.log(local); // logs "3"
}());

(function () {
    var local = 1;
    Function("console.log(typeof local);")(); // logs undefined
}());