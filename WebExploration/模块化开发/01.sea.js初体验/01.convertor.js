/**
 * Created by wdy on 2017/5/21.
 */

/**
 * 转换模块，导出成员：convertToNumber
 */
define(function(require, exports, module) {
    // 公开一些转换逻辑
    exports.convertToNumber = function(input) {
        return parseFloat(input);
    }
});
