/**
 * Created by wdy on 2017/5/10.
 */
var str = "helloChina";
//方法1：
console.log(str.split("").reverse().join("") );

//方法2：
// for (var x = str.length-1; x >=0; x--)
// {
//     document.write(str.charAt(x));
// }
// 方法3：
// var a=str.split("");
// var rs = new Array;
// while(a.length)
// {
//     rs.push(a.pop());
// }
// console.log(rs.join(""));