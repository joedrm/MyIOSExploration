//
//  NetworkManager.h
//  Pods
//
//  Created by fang wang on 17/1/4.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestType) {
    GetRequest = 0,
    PostRequest,
    PutRequest,
    DeleteRequest
};



NS_ASSUME_NONNULL_BEGIN
@interface NetworkManager : NSObject

+ (instancetype)shareManager;

/*!
 *  设置请求超时时间  默认10s
 */
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

/*!
 *  根据type请求
 */
- (void)request:(NSString *)url
           type:(RequestType)type
         params:(NSDictionary *)params
        success:(void (^)(id response))success
        failure:(nullable void (^)(NSError *error))failure;

/*!
 *  上传文件
 */
- (void)post:(NSString *)url
      params:(NSDictionary *)params
        body:(void (^)(id<AFMultipartFormData> formData))body
     success:(void (^)(id response))success
     failure:(nullable void (^)(NSError *error))failure;

/*!
 *  下载文件
 */
- (void)downloadFile:(NSString *)url progress:(void (^)(CGFloat progress))progress;

/*!
 *  取消网络请求
 */
- (void)cancelAllRequest;

/*!
 *  监听网络状态
 */
+ (void)observeNetworkStatus:(void (^)(AFNetworkReachabilityStatus status))block;

/*!
 *  移除网络状态监听
 */
+ (void)removeNetworkStatusObserver;

/*!
 *  开启请求的URLcache
 */
+ (void)openRequsetCache;

/*!
 *  移除所有的URLcache
 */
+ (void)removeAllCachedResponses;

@end

NS_ASSUME_NONNULL_END
