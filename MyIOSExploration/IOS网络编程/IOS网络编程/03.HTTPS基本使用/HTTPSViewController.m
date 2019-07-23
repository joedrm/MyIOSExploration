//
//  HTTPSViewController.m
//  IOS网络编程
//
//  Created by wdy on 2017/7/1.
//  Copyright © 2017年 wdy. All rights reserved.
//

#import "HTTPSViewController.h"
#import "AFNetworking.h"

@interface HTTPSViewController ()<NSURLSessionDataDelegate>

@end

@implementation HTTPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)session:(UIButton *)sender {
    
    NSURL* url = [NSURL URLWithString:@"http://47.98.148.183/"];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@", dataStr);
    }];
    
    [dataTask resume];
    
}



/**
 NSURLSessionDelegate 代理

 @param session 网络请求
 @param challenge 质询，就是询问需不需要下载服务器的证书
 @param completionHandler 回调
 
 该方法只有发送https请求的时候才调用
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"]) {
        return;
    }
    
    // protectionSpace 受保护空间
    /** 打印结果：
     <NSURLProtectionSpace: 0x600000011cd0>: Host:kyfw.12306.cn, Server:https, Auth-Scheme:NSURLAuthenticationMethodServerTrust, Realm:(null), Port:443, Proxy:NO, Proxy-Type:(null)
     */
    NSLog(@"%@", challenge.protectionSpace);

    /*
     NSURLSessionAuthChallengeDisposition: 如何处理证书,是一个枚举值：
         NSURLSessionAuthChallengeUseCredential = 0, 使用（安装）该证书
         NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认采用的方式，该证书被忽略
         NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 取消请求，证书忽略
         NSURLSessionAuthChallengeRejectProtectionSpace = 3, 拒绝
     
     NSURLCredential：授权信息
     */
    NSURLCredential* credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}


- (IBAction)afn:(UIButton *)sender {
    
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置对证书的处理方式
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    
    NSString* url = @"http://47.98.148.183/";//@"https://kyfw.12306.cn/otn"
    
    [manager GET:url parameters:@{@"username" : @"wdy", @"password" : @"123456"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success---%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error---%@",error);
    }];
}

@end
