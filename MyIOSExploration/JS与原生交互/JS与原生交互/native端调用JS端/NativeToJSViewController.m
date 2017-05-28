//
//  NativeToJSViewController.m
//  JS与原生交互
//
//  Created by wdy on 2017/5/25.
//  Copyright © 2017年 com.wdy.MyIOSExploration. All rights reserved.
//

#import "NativeToJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface NativeToJSViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NativeToJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIButton * callJSFunctioinBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, 80, 44)];
    callJSFunctioinBtn.backgroundColor = [UIColor redColor];
    callJSFunctioinBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [callJSFunctioinBtn setTitle:@"调用JS方法" forState:(UIControlStateNormal)];
    [callJSFunctioinBtn addTarget:self action:@selector(clickCallJSFunctionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:callJSFunctioinBtn];
    
    CGRect webViewFrame = CGRectMake(0, 144, ScreenWidth, ScreenHeight - 100);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    webView.delegate = self;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    
}


// 传参数
//- (void)clickCallJSFunctionBtn:(UIButton *)btn{
//    [self.webView stringByEvaluatingJavaScriptFromString:@"callJSFunction(\"100\")"];
//}

// 传递一个数组或者字典
// 需要使用 JavaScriptcore
- (void)clickCallJSFunctionBtn:(UIButton *)btn{
    /**
     1. 定义一个简单的字典，用于被传递的参数
     2. 获取当前webView的JavaScriptContext。是的，只可以通过KVC这个黑魔法来获取key = documentView.webView.mainFrame.javaScriptContext这个环境包含了当前webView定义的JavaScript方法。
     3. 为这个JScontext设置语法执行异常结果回调。如果JS语法错误，那么就会执行这个block回调，并提示一些语法错误信息让我们参考。
     定义一个类型为JSValue的jsFunction，并在context[@"callJSFunctionWithParam"]为其赋值。callJSFunctionWithParam这个就是在当前webView环境定义的方法。什么是JSValue呢？点击查看这个它的定义:
            A JSValue is a reference to a value within the JavaScript object space of a JSVirtualMachine. All instances of JSValue originate from a JSContext and hold a strong reference to this JSContext.
     4. 从上面我们知道它在JVM环境中，它代表任何从JSContext获取的实例，无论整型，字符型，数组还是方法。跟上面那样的获取，返回值都是一个JSValue
     
     5. 最后，调用callWithArguments这个方法，用数组的方式将参数h包装起来并发送过去。点击进入该方法所在的头文件JSValue.h中，你发现很多关于方法声明，参数都是通过数组的方式包装过去的。要记得，参数传递的数组要跟JS方法定义的列表保持一致的。
     */
    NSDictionary * params = @{@"bgColor":@"blue",
                              @"left":@"300"};
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context setExceptionHandler:^(JSContext *context, JSValue *value) {
        NSLog(@"JS exception: %@", value);
    }];
    JSValue *jsFunction = context[@"callJSFunctionWithParam"];
    [jsFunction callWithArguments:@[params]];
    
    /*
     如果将index.html文件中JS方法添加返回值，类型假如是String类型。那么在native端的事件点击事件方法中修改为：
     */
    NSLog(@"js return value:%@",[jsFunction toString]);
}

@end






