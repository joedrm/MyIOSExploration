//
//  ViewController.m
//  UITableView性能优化
//
//  Created by wangdongyang on 16/9/5.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

/*
 UITableView性能优化:
     复用cell
     缓存cell
     缓存高度
     减少subview的数量，使用drawrect绘制，这样可以利用GPU离屏渲染
     避免图形特效，图片缩放颜色渐变等。
     设置不透明
     不要阻塞主线程，将处理放到子线程中去处理设置最大线程数为2，利用NSOperationQueue的maxConcurrentOperationCount为2
*/

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UITableView常用功能实现及性能优化";
    self.titleArr = @[
                      @"支持不同类型的Cell"
                      ];
    
    
    self.vcArr = @[
                   @"ChatViewController"
                   
                   ];
}

@end


/*
 http://itangqi.me/tags/UITableView/  聊一聊UITableView
 https://github.com/NianJi/NJEasyTable  能够缓存cell高度，避免重复计算,实现不同的Cell的显示
 
 优雅地分离tableview回调：http://www.cocoachina.com/ios/20161008/17687.html；https://github.com/haltNoShut/YFAssistantTableView

 */
