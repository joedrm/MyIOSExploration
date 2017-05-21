/*
 * @Author: iceStone
 * @Date:   2016-02-17 15:15:22
 * @Last Modified by:   iceStone
 * @Last Modified time: 2016-02-19 10:49:05
 */

'use strict';

(function(angular) {
  // 由于默认angular提供的异步请求对象不支持自定义回调函数名
  // angular随机分配的回调函数名称不被豆瓣支持
  var http = angular.module('moviecat.services.http', []);
  http.service('HttpService', ['$window', '$document', function($window, $document) {
    // url : http://api.douban.com/vsdfsdf -> <script> -> html就可自动执行
    this.jsonp = function(url, data, callback) {
      // if (typeof data == 'function') {
      //   callback = data;
      // }
      var querystring = url.indexOf('?') == -1 ? '?' : '&';
      for (var key in data) {
        querystring += key + '=' + data[key] + '&';
      }

      var fnSuffix = Math.random().toString().replace('.', '');
      var cbFuncName = 'my_json_cb_' + fnSuffix;
      querystring += 'callback=' + cbFuncName;

      var scriptElement = $document[0].createElement('script');
      scriptElement.src = url + querystring;
      // 不推荐
      $window[cbFuncName] = function(data) {
        callback(data);
        $document[0].body.removeChild(scriptElement);
      };
      $document[0].body.appendChild(scriptElement);
    };
  }]);
})(angular);
