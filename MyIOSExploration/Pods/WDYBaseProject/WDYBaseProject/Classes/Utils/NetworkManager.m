//
//  NetworkManager.m
//  Pods
//
//  Created by fang wang on 17/1/4.
//
//

#import "NetworkManager.h"

@implementation NSData (utils)

- (NSDictionary *)parseJson {
    NSError *error;
    id response = [NSJSONSerialization JSONObjectWithData:self
                                                  options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                           error:&error];
    return response;
}

@end

static NSString *const kRequest_TimeOutKeyPath = @"timeoutInterval";

@interface NetworkManager (){
    AFHTTPSessionManager *_requestManager;
}

@end

@implementation NetworkManager

+ (instancetype)shareManager{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _requestManager = [AFHTTPSessionManager manager];
        _requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self setTimeoutInterval:10.0];
    }
    return self;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [_requestManager.requestSerializer willChangeValueForKey:kRequest_TimeOutKeyPath];
    _requestManager.requestSerializer.timeoutInterval = timeoutInterval;
    [_requestManager.requestSerializer didChangeValueForKey:kRequest_TimeOutKeyPath];
    
}

#pragma mark-   request

- (void)request:(NSString *)url
           type:(RequestType)type
         params:(NSDictionary *)params
        success:(void (^)(id response))success
        failure:(void (^)(NSError *error))failure {
    
    // 请求成功的回调
    void (^successfulRequest) (NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            id response = [responseObject parseJson];
            success(response);
        }
    };
    
    // 请求失败的回调
    void (^failedRequest) (NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) failure(error);
    };
    
    switch (type) {
        case GetRequest: {
            [_requestManager GET:url
                      parameters:params
                        progress:nil
                         success:successfulRequest
                         failure:failedRequest];
        }
            break;
            
        case PostRequest: {
            [_requestManager POST:url
                       parameters:params
                         progress:nil
                          success:successfulRequest
                          failure:failedRequest];
        }
            break;
            
        case PutRequest: {
            [_requestManager PUT:url
                      parameters:params
                         success:successfulRequest
                         failure:failedRequest];
        }
            break;
            
        case DeleteRequest: {
            [_requestManager DELETE:url
                         parameters:params
                            success:successfulRequest
                            failure:failedRequest];
        }
            break;
            
        default:
            break;
    }
}

- (void)post:(NSString *)url
      params:(NSDictionary *)params
        body:(void (^)(id<AFMultipartFormData> formData))body
     success:(void (^)(id response))success
     failure:(void (^)(NSError *error))failure {
    
    [_requestManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (body) body(formData);
    }
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (success) {
                          id response = [responseObject parseJson];
                          success(response);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failure) failure(error);
                  }];
}

- (void)cancelAllRequest {
    [_requestManager.operationQueue cancelAllOperations];
}

#pragma mark-  download

- (void)downloadFile:(NSString *)url progress:(void (^)(CGFloat progress))progress {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress)
            progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}


#pragma mark-  network status

+ (void)observeNetworkStatus:(void (^)(AFNetworkReachabilityStatus status))block {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block)
            block(status);
    }];
}

+ (void)removeNetworkStatusObserver {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark-  cache

+ (void)openRequsetCache {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

+ (void)removeAllCachedResponses {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
