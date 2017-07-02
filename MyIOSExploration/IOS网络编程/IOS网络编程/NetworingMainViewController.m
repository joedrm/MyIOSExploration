//
//  ViewController.m
//  IOS网络编程
//
//  Created by fang wang on 17/2/17.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "NetworingMainViewController.h"

@interface NetworingMainViewController ()

@end

@implementation NetworingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"网络编程";
    self.titleArr = @[
                      @"03.HTTPS基本使用"
                      ];
    
    self.vcArr = @[
                   @"HTTPSViewController"
                   ];
    
//    [self getData];
}


- (void)getData{
    NSURL* url = [NSURL URLWithString:@"https://www.v2ex.com/api/topics/hot.json"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // NSLog(@"%@ %tu", response, data.length);
        // 类型转换（如果将父类设置给子类，需要强制转换）
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"statusCode == %@", @(httpResponse.statusCode));
        // 判断响应的状态码是否是 304 Not Modified （更多状态码含义解释： https://github.com/ChenYilong/iOSDevelopmentTips）
        if (httpResponse.statusCode == 304) {
            NSLog(@"加载本地缓存图片");
            // 如果是，使用本地缓存
            // 根据请求获取到`被缓存的响应`！
            NSCachedURLResponse *cacheResponse =  [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            // 拿到缓存的数据
            data = cacheResponse.data;
        }
        
        NSError *errorJson;
        NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
        for (NSDictionary* obj in jsonDict) {
            NSLog(@"obj = %@", obj[@"content"]);
        }
        
    }] resume];
    
}

@end

/*
 http://www.jianshu.com/p/fb5aaeac06ef  iOS网络缓存扫盲篇--使用两行代码就能完成80%的缓存需求
 
 https://github.com/QianKun-HanLin/HLNetworking  基于AFNetworking的高阶网络请求管理器
 
 http://www.jianshu.com/p/f9b4ada163ab  一步一步构建你的iOS网络层 - HTTP篇
 http://www.jianshu.com/p/2f98823730a8  一步一步构建你的iOS网络层 - TCP篇

 http://www.jianshu.com/p/d7e549249a01 iOS 工作中封装通用性网络请求框架 
 
 https://github.com/kangzubin/XMNetworking  一个轻量的、简单易用但功能强大的网络库，基于 AFNetworking 3.0 封装
 
 https://github.com/mmoaay/MBNetwork  
 
 http://itangqi.me/categories/HTTP/  《图解 HTTP》读书笔记
 
 https://github.com/jkpang/PPNetworkHelper AFNetworking 3.x 与YYCache封装,一句代码搞定数据请求与缓存,告别FMDB!控制台直接打印json中文字符,调试更方便
 
 https://github.com/lianleven/LYHTTPClient  缓存用的是YYCache，基于AFNetworking的封装
 
 https://github.com/guowilling/SRDownloadManager  多线程文件下载管理
 
 
 http://www.itwendao.com/article/detail/221283.html  iOS 使用 socket 即时通信（非第三方库）
 */
