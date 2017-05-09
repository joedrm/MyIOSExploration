/*
 * 自己的JS脚步
 * @Author: iceStone
 * @Date:   2015-12-12 10:59:26
 * @Last Modified by:   iceStone
 * @Last Modified time: 2015-12-15 16:23:12
 */

'use strict';

$(function() {
  // 当文档加载完成才会执行
  /**
   * 根据屏幕宽度的变化决定轮播图片应该展示什么
   * @return {[type]} [description]
   */
  function resize() {
    // 获取屏幕宽度
    var windowWidth = $(window).width();
    // 判断屏幕属于大还是小
    var isSmallScreen = windowWidth < 768;
    // 根据大小为界面上的每一张轮播图设置背景
    // $('#main_ad > .carousel-inner > .item') // 获取到的是一个DOM数组（多个元素）
    $('#main_ad > .carousel-inner > .item').each(function(i, item) {
      // 因为拿到是DOM对象 需要转换
      var $item = $(item);
      // var imgSrc = $item.data(isSmallScreen ? 'image-xs' : 'image-lg');
      var imgSrc =
        isSmallScreen ? $item.data('image-xs') : $item.data('image-lg');

      // 设置背景图片
      $item.css('backgroundImage', 'url("' + imgSrc + '")');
      //
      // 因为我们需要小图时 尺寸等比例变化，所以小图时我们使用img方式
      if (isSmallScreen) {
        $item.html('<img src="' + imgSrc + '" alt="" />');
      } else {
        $item.empty();
      }
    });
  }

  $(window).on('resize', resize).trigger('resize');

  // 初始化tooltips插件
  $('[data-toggle="tooltip"]').tooltip();

  /**
   * 控制标签页的标签容器宽度
   */
  var $ulContainer = $('.nav-tabs');
  // 获取所有子元素的宽度和
  var width = 30; // 因为原本ul上有padding-left
  // 遍历子元素
  $ulContainer.children().each(function(index, element) {
    // console.log(element.clientWidth);
    // console.log($(element).width());
    width += element.clientWidth;
  });
  // 此时width等于所有LI的宽度总和
  // 判断当前UL的宽度是否超出屏幕，如果超出就显示横向滚动条
  if (width > $(window).width()) {

    $ulContainer
      .css('width', width)
      .parent().css('overflow-x', 'scroll');
  }

  // a点击注册事件
  var $newTitle = $('.news-title');
  $('#news .nav-pills a').on('click', function() {
    // 获取当前点击元素
    var $this = $(this);
    // 获取对应的title值
    var title = $this.data('title');
    // 将title设置到相应的位置
    $newTitle.text(title);
  });

  // 1. 获取手指在轮播图元素上的一个滑动方向（左右）



  // 获取界面上的轮播图容器
  var $carousels = $('.carousel');
  var startX, endX;
  var offset = 50;
  // 注册滑动事件
  $carousels.on('touchstart', function(e) {
    // 手指触摸开始时记录一下手指所在的坐标X
    startX = e.originalEvent.touches[0].clientX;
    // console.log(startX);
  });

  $carousels.on('touchmove', function(e) {
    // 变量重复赋值
    endX = e.originalEvent.touches[0].clientX;
    // console.log(endX);
  });
  $carousels.on('touchend', function(e) {
    console.log(e);
    // 结束触摸一瞬间记录最后的手指所在坐标X
    // 比大小
    // console.log(endX);
    // 控制精度
    // 获取每次运动的距离，当距离大于一定值时认为是有方向变化
    var distance = Math.abs(startX - endX);
    if (distance > offset) {
      // 有方向变化
      // console.log(startX > endX ? '←' : '→');
      // 2. 根据获得到的方向选择上一张或者下一张
      //     - $('a').click();
      //     - 原生的carousel方法实现 http://v3.bootcss.com/javascript/#carousel-methods
      $(this).carousel(startX > endX ? 'next' : 'prev');
    }
  });




});
