//
//  AppDelegate.h
//  YYKitExample
//
//  Created by ibireme on 14-9-18.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYRootViewController.h"

@interface YYAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *rootViewController;
@end

/* 资料
 
 https://github.com/Charlesyaoxin/NeiHanDuanZI  YY框架的实践项目，CustomTableViewController的封装，很不错的开源项目
 https://github.com/DSKcpp/PPAsyncDrawingKit  轻量的异步绘制框架，实现一系列 ImageView, Label, Button 等基础控件
 https://github.com/johnil/VVeboTableViewDemo  如何进行TableView流畅度优化的
 https://github.com/lzwjava/OpenSourceNotes/blob/master/YYText/YYText.md  YYText 是如何绘制的
 https://github.com/seedante/iOS-Note/wiki/Mastering-Offscreen-Render  离屏渲染
 
 
 
 
 
 
 */
