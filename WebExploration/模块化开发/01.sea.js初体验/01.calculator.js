/**
 * Created by wdy on 2017/5/21.
 */


define(function (require, exports, module) {

    var convertor = require('./01.convertor.js');

    function add(a, b) {
        return convertor.convertToNumber(a) + convertor.convertToNumber(b);
    }

    function subtract(a, b) {
        return convertor.convertToNumber(a) - convertor.convertToNumber(b);
    }

    function multiply(a, b) {
        return convertor.convertToNumber(a) * convertor.convertToNumber(b);
    }

    function divide(a, b) {
        return convertor.convertToNumber(a) / convertor.convertToNumber(b);
    }
    // 暴露模块的公共成员
    exports.add = add;
    exports.subtract = subtract;
    exports.multiply = multiply;
    exports.divide = divide;
});