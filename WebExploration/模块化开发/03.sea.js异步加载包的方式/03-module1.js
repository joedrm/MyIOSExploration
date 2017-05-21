/*
 * @Author: iceStone
 * @Date:   2016-02-19 16:52:23
 * @Last Modified by:   iceStone
 * @Last Modified time: 2016-02-19 17:03:00
 */

define(function (require, exports, module) {
    // console.log('module1 ---- start');
    // // require 必须执行完成过后（./module2.js加载完成）才可以拿到返回值
    // var module2 = require('./03-module2.js'); // 阻塞代码执行
    // // JS中的阻塞会有卡顿的情况出现
    // console.log('module1 ---- end');
    //
    console.log('module1 ---- start');
    require.async('./03-module2.js', function (module2) {

    }); // 此处不会阻塞代码执行

    console.log('module1 ---- end');
});
