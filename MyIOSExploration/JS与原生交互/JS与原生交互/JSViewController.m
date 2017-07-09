//
//  ViewController.m
//  JS与原生交互
//
//  Created by wdy on 2017/5/25.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "JSViewController.h"

@interface JSViewController ()

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"JS与原生交互";
    
    self.titleArr = @[
                      @"native端调用JS端",
                      @"JS端调用native端"
                      
                      
                      ];
    
    self.vcArr = @[
                   @"NativeToJSViewController",
                   @"JSToNativeViewController"
                   
                   ];
}


/**
 http://kittenyang.com/webview-javascript-bridge/  UIWebView与JS的深度交互
 
 http://www.cocoachina.com/ios/20160127/15105.html Objective-C与JavaScript交互的那些事
 
 https://github.com/DarkAngel7/Demos-WebViewDemo  iOS中UIWebView与WKWebView、JavaScript与OC交互、Cookie管理看我就够上、中、下
 
 https://github.com/shaojiankui/iOS-WebView-JavaScript iOS UIWebView,WKWebView 与 JavaScript的深度交互
 
 WebView
 
 https://github.com/LSure/SureWebViewController
 */


@end
