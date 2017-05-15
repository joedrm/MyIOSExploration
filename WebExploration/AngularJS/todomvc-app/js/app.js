(function(angular) {
  'use strict';


  // 1. 为应用程序创建一个模块，用来管理界面的结构
  var myApp = angular.module('app', ['ngRoute', 'app.controllers.main']);

  // 路由配置
  myApp.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    // /asdasda {status:asdasda}
      .when('/:status?', {
        controller: 'MainController',
        templateUrl: 'main_tmpl'
      })
      .otherwise({ redirectTo: '/' });
  }]);




  // // 2. 注册一个主要的控制器（属于某个模块），用于往视图（view）中暴露数据
  // myApp.controller('MainController', ['$scope', '$location', function($scope, $location) {
  //   // [1,2,3,4,5]
  //   // 获取唯一ID
  //   function getId() {
  //     var id = Math.random(); // 1 2
  //     for (var i = 0; i < $scope.todos.length; i++) {
  //       if ($scope.todos[i].id === id) {
  //         id = getId();
  //         break;
  //       }
  //     }
  //     return id;
  //   }

  //   // 文本框需要一个模型，为了拿到文本输入的值
  //   $scope.text = '';

  //   // 任务列表也需要一个
  //   // 每一个任务的结构 { id: 1, text: '学习', completed: true }
  //   $scope.todos = [{
  //     id: 0.123,
  //     text: '学习',
  //     completed: false
  //   }, {
  //     id: 0.22,
  //     text: '睡觉',
  //     completed: false
  //   }, {
  //     id: 0.232,
  //     text: '打豆豆',
  //     completed: true
  //   }];

  //   // 添加todo
  //   $scope.add = function() {
  //     if (!$scope.text) {
  //       return;
  //     }
  //     $scope.todos.push({
  //       // 自动增长？
  //       id: getId(),
  //       // 由于$scope.text是双向绑定的，add同时肯定可以同他拿到界面上的输入
  //       text: $scope.text,
  //       completed: false
  //     });
  //     // 清空文本框
  //     $scope.text = '';
  //   };


  //   // 处理删除
  //   $scope.remove = function(id) {
  //     // 删除谁
  //     for (var i = 0; i < $scope.todos.length; i++) {
  //       if ($scope.todos[i].id === id) {
  //         $scope.todos.splice(i, 1);
  //         break;
  //       }
  //     }
  //     // $scope.todos
  //   };

  //   // 清空已完成
  //   $scope.clear = function() {
  //     var result = [];
  //     for (var i = 0; i < $scope.todos.length; i++) {
  //       if (!$scope.todos[i].completed) {
  //         result.push($scope.todos[i]);
  //       }
  //     }
  //     $scope.todos = result;
  //   };

  //   // 是否有已经完成的
  //   $scope.existCompleted = function() {
  //     // 该函数一定要有返回值
  //     for (var i = 0; i < $scope.todos.length; i++) {
  //       if ($scope.todos[i].completed) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   };

  //   // 当前编辑哪个元素
  //   $scope.currentEditingId = -1;
  //   // -1代表一个肯定不存在的元素，默认没有任何被编辑
  //   $scope.editing = function(id) {
  //     $scope.currentEditingId = id;
  //   };
  //   $scope.save = function() {
  //     $scope.currentEditingId = -1;
  //   };

  //   // $scope.checkall = false;
  //   // $scope.$watch('checkall', function(now, old) {
  //   //   for (var i = 0; i < $scope.todos.length; i++) {
  //   //     $scope.todos[i].completed = now;
  //   //   }
  //   // });

  //   var now = true;
  //   $scope.toggleAll = function() {
  //     for (var i = 0; i < $scope.todos.length; i++) {
  //       $scope.todos[i].completed = now;
  //     }
  //     now = !now;
  //   }

  //   // 状态筛选
  //   $scope.selector = {}; // {} {completed:true} {completed:false}
  //   // 点击事件的方式不合适，有DOM操作
  //   // 让$scope也有一个指向$location的数据成员
  //   $scope.$location = $location;
  //   // watch只能监视属于$scope的成员
  //   $scope.$watch('$location.path()', function(now, old) {
  //     // 1. 拿到锚点值
  //     // 这样写就要求执行环境必须要有window对象
  //     // var hash = window.location.hash;
  //     // console.log($location);
  //     // console.log(now);
  //     // 2. 根据锚地值对selector做变换
  //     switch (now) {
  //       case '/active':
  //         $scope.selector = { completed: false };
  //         break;
  //       case '/completed':
  //         $scope.selector = { completed: true };
  //         break;
  //       default:
  //         $scope.selector = {};
  //         break;
  //     }
  //   });

  //   // 自定义比较函数, 默认filter过滤器使用的是模糊匹配
  //   $scope.equalCompare = function(source, target) {
  //     // console.log(source);
  //     // console.log(target);
  //     // return false;
  //     return source === target;
  //   };
  // }]);

})(angular);
