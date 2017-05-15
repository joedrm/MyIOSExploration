/*
 * @Author: iceStone
 * @Date:   2016-02-16 16:54:35
 * @Last Modified by:   iceStone
 * @Last Modified time: 2016-02-16 17:52:19
 */

(function(angular) {
  'use strict';

  // 独立的模块
  var controllers = angular.module('app.controllers.main', ['app.services.main']);

  controllers.controller('MainController', [
    '$scope',
    '$routeParams',
    '$route',
    'MainService',
    function($scope, $routeParams, $route, MainService) {

      // 文本框需要一个模型，为了拿到文本输入的值
      $scope.text = '';

      // 任务列表也需要一个
      // 每一个任务的结构 { id: 1, text: '学习', completed: true }
      $scope.todos = MainService.get();

      // 添加todo
      $scope.add = function() {
        // 参数校验 界面逻辑
        if (!$scope.text) {
          return;
        }
        MainService.add($scope.text);
        console.log('addddddd');
        // 清空文本框
        $scope.text = '';
      };


      // 处理删除
      $scope.remove = MainService.remove; //function(id) {
      //   // 此处是界面逻辑
      //   MainService.remove(id);
      // };

      // 清空已完成
      $scope.clear = function() {
        var newTodos = MainService.clearCompleted();
        $scope.todos = newTodos;
      };

      // 是否有已经完成的
      $scope.existCompleted = MainService.existCompleted;

      // 当前编辑哪个元素
      $scope.currentEditingId = -1;
      // -1代表一个肯定不存在的元素，默认没有任何被编辑
      $scope.editing = function(id) {
        // 界面逻辑
        $scope.currentEditingId = id;
      };
      $scope.save = function() {
        $scope.currentEditingId = -1;
      };

      // $scope.checkall = false;
      // $scope.$watch('checkall', function(now, old) {
      //   for (var i = 0; i < $scope.todos.length; i++) {
      //     $scope.todos[i].completed = now;
      //   }
      // });

      $scope.toggleAll = MainService.toggleAll;

      $scope.toggle = function() {
        MainService.save();
      }

      // 状态筛选
      $scope.selector = {}; // {} {completed:true} {completed:false}
      // 取路由中匹配出来的数据
      var status = $routeParams.status;
      switch (status) {
        case 'active':
          $scope.selector = { completed: false };
          break;
        case 'completed':
          $scope.selector = { completed: true };
          break;
        default:
          // / /sdfsdf
          $route.updateParams({ status: '' });
          $scope.selector = {};
          break;
      }

      // 自定义比较函数, 默认filter过滤器使用的是模糊匹配
      $scope.equalCompare = function(source, target) {
        // console.log(source);
        // console.log(target);
        // return false;
        return source === target;
      };
    }
  ]);

})(angular);
