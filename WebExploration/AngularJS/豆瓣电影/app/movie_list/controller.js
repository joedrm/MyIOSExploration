(function(angular) {
  'use strict';

  // 创建正在热映模块
  var module = angular.module(
    'moviecat.movie_list', [
      'ngRoute',
      'moviecat.services.http'
    ]);
  // 配置模块的路由
  module.config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/:category/:page', {
      templateUrl: 'movie_list/view.html',
      controller: 'MovieListController'
    });
  }]);

  module.controller('MovieListController', [
    '$scope',
    '$route',
    '$routeParams',
    'HttpService',
    'AppConfig',
    function($scope, $route, $routeParams, HttpService, AppConfig) {
      var count = AppConfig.pageSize; // 每一页的条数
      var page = parseInt($routeParams.page); // 当前第几页
      var start = (page - 1) * count; // 当前页从哪开始
      // 控制器 分为两步： 1. 设计暴露数据，2. 设计暴露的行为
      $scope.loading = true; // 开始加载
      $scope.subjects = [];
      $scope.title = 'Loading...';
      $scope.message = '';
      $scope.totalCount = 0;
      $scope.totalPages = 0;
      $scope.currentPage = page;
      HttpService.jsonp(
        AppConfig.listApiAddress + $routeParams.category,
        // $routeParams 的数据来源：1.路由匹配出来的，2.?参数
        { start: start, count: count, q: $routeParams.q },
        function(data) {
          $scope.title = data.title;
          $scope.subjects = data.subjects;
          $scope.totalCount = data.total;
          $scope.totalPages = Math.ceil($scope.totalCount / count);
          $scope.loading = false;
          $scope.$apply();
          // $apply的作用就是让指定的表达式重新同步
        });

      // 暴露一个上一页下一页的行为
      $scope.go = function(page) {
        // 传过来的是第几页我就跳第几页
        // 一定要做一个合法范围校验
        if (page >= 1 && page <= $scope.totalPages)
          $route.updateParams({ page: page });
      };
    }
  ]);
})(angular);





// var doubanApiAddress = 'http://api.douban.com/v2/movie/in_theaters';
// // 测试$http服务
// // 在Angular中使用JSONP的方式做跨域请求，
// // 就必须给当前地址加上一个参数 callback=JSON_CALLBACK
// $http.jsonp(doubanApiAddress+'?callback=JSON_CALLBACK').then(function(res) {
//   // 此处代码是在异步请求完成过后才执行（需要等一段时间）
//   if (res.status == 200) {
//     $scope.subjects = res.data.subjects;
//   } else {
//     $scope.message = '获取数据错误，错误信息：' + res.statusText;
//   }
// }, function(err) {
//   console.log(err);
//   $scope.message = '获取数据错误，错误信息：' + err.statusText;
// });
