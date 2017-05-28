//
//  JSToNativeViewController.m
//  JS与原生交互
//
//  Created by wdy on 2017/5/25.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "JSToNativeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Student.h"

@interface JSToNativeViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;


@end

@implementation JSToNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * callJSFunctioinBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, 80, 36)];
    callJSFunctioinBtn.backgroundColor = [UIColor redColor];
    callJSFunctioinBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [callJSFunctioinBtn setTitle:@"调用JS方法" forState:(UIControlStateNormal)];
    [callJSFunctioinBtn addTarget:self action:@selector(clickCallJSFunctionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:callJSFunctioinBtn];
    
    CGRect webViewFrame = CGRectMake(0, 150, ScreenWidth, ScreenHeight - 100);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    webView.delegate = self;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    
    self.summerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 64, 80, 80)];
    [self.view addSubview:self.summerImageView];
}

- (void)clickCallJSFunctionBtn:(UIButton *)btn{
    // [self.webView stringByEvaluatingJavaScriptFromString:@"callJSFunction()"];
    
    // [self.webView stringByEvaluatingJavaScriptFromString:@"callJSFunctionWithParam(\"mary\")"];
    
    NSArray * params = @[@"tony",@"zack",@"kson"];
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"JS exception: %@", value);
    }];
    JSValue *jsFunction = context[@"callJSFunctionWithParam"];
    JSValue * jsReturnValue =  [jsFunction callWithArguments:@[params]];
    NSLog(@"js return value:%@",[jsReturnValue toString]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webView finsh load");
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"WEB JS: %@", value);
    }];
    
    Student * kson = [[Student alloc] init];
    kson.viewController = self;
    context[@"myStudent"] = kson;
    
    NSString * str =
    @"function spring () {"
    "   myStudent.takePhoto();}"
    "var btn = document.getElementById(\"pid\");"
    "btn.addEventListener('click', spring);";
    
    [context evaluateScript:str];
    
}


/*
 步骤：
 
 1. 首先获取当前webView的JavaScript环境
 2. 设置JS代码语法运行handler block
 3. 定义一个Student带对象，并将其注册到JavaScript环境中。因为Student对象已经遵守了JSExport协议，因此该类型对象在JavaScript环境是可见(可以被访问)。
 4. 定义一个JS的方法，名称叫spring。作用就是先调用上面注册的原生对象myStudent的方法takePhoto().然后获取HTML文件中定义的按钮，并为这个按钮添加点击的监听事件，事件就是spring。最后将其拼接成为一个脚步字符串。
 5. 最后context将上面脚本同样注册到JS环境中。
 
 */

@end
