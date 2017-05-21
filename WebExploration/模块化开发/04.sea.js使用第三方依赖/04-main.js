/*
 * @Author: iceStone
 * @Date:   2016-02-19 17:12:42
 * @Last Modified by:   iceStone
 * @Last Modified time: 2016-02-19 17:19:17
 */

'use strict';

/**
 由于 CMD 是国产库, jquery 目前还不支持

 适配 CMD, 加上下面这一句

 if (typeof define === "function" && !define.amd) {
        // 当前有define函数，并且不是AMD的情况
        // jquery在新版本中如果使用AMD或CMD方式，不会去往全局挂载jquery对象
        define(function () {
            return jQuery.noConflict(true);
        });
    }
 */

define(function (require, exports, module) {
    // 想用jquery怎么办
    var $ = require('./jquery.js');
    console.log($);
    $(document.body).css('backgroundColor', 'red');
});
