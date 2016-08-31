//
//  TUBaseRequest.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUNetworkDefine.h"
#import "TUNetworkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
@import AFNetworking;
#endif

NS_ASSUME_NONNULL_BEGIN

@class TUBaseRequest;

typedef NSURL * _Nullable (^AFDownloadDestinationBlock)(NSURL *targetPath, NSURLResponse *response);
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFProgressBlock)(NSProgress *progress);
typedef void (^TURequestSuccess)(__kindof TUBaseRequest *baseRequest, id _Nullable responseObject);
typedef void (^TURequestFailur)(__kindof TUBaseRequest *baseRequest, NSError *error);
typedef void (^TURequestCacheCompletion)(__kindof TUBaseRequest *baseRequest, id _Nullable cacheResult, NSError *error);

/**
 *  基本请求
 */
@interface TUBaseRequest : NSObject

@property (nonatomic,   copy) _Nullable TURequestSuccess successBlock;
@property (nonatomic,   copy) _Nullable TURequestFailur failurBlock;
@property (nonatomic,   copy) _Nullable TURequestCacheCompletion cacheCompletionBlcok;
@property (nonatomic, strong) _Nullable id responseObject;
/// 请求的Task
@property (nonatomic, strong) NSURLSessionTask *requestTask;
/// 请求优先级
@property (nonatomic, assign) TURequestPriority requestPriority;
/// 请求的缓存选项
@property (nonatomic, assign) TURequestCacheOption cacheOption;

/**
 *  发送请求
 *
 *  @param success  成功的回调
 *  @param failur   失败的回调
 */
- (void)sendRequestWithSuccess:(TURequestSuccess _Nullable)success
                        failur:(TURequestFailur _Nullable)failur;

/**
 *  发送请求（缓存）
 *
 *  @param cache    缓存读取完的回调
 *  @param success  成功的回调
 *  @param failur   失败的回调
 */
- (void)sendRequestWithCache:(TURequestCacheCompletion _Nullable)cache
                     success:(TURequestSuccess _Nullable)success
                      failur:(TURequestFailur _Nullable)failur;

/**
 *  取消请求
 */
- (void)cancelRequest;

/**
 *  清理网络回调block
 */
- (void)clearCompletionBlock;

/**
 *  请求的protocol
 *
 *  @return NSString
 */
- (NSString *)appProtocol;

/**
 *  请求的Host
 *
 *  @return NSString
 */
- (NSString *)appHost;

/**
 *  请求的URL
 *
 *  @return NSString
 */
- (NSString *)requestUrl;

/**
 *  请求的连接超时时间，默认为60秒
 *
 *  @return NSTimeInterval
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 *  请求的参数列表
 *  POST时放在body中
 *
 *  @return NSDictionary
 */
- (NSDictionary *)requestParameters;

/**
 *  请求的方法(GET,POST...)
 *
 *  @return TURequestMethod
 */
- (TURequestMethod)requestMethod;

/**
 *  请求的SerializerType
 *
 *  @return TURequestSerializerType
 */
- (TURequestSerializerType)requestSerializerType;

/**
 *  请求公参的位置
 *
 *  @return TURequestPublicParametersType
 */
- (TURequestPublicParametersType)requestPublicParametersType;

/**
 *  证书配置
 *
 *  @return AFSecurityPolicy
 */
- (AFSecurityPolicy *)requestSecurityPolicy;

/**
 *  在HTTP报头添加的自定义参数
 *
 *  @return NSDictionary
 */
- (NSDictionary *)requestHeaderFieldValueDictionary;

/**
 *  请求的回调
 */
- (void)requestHandleResult;

/**
 *  请求缓存的回调
 *
 *  @param cacheResult 缓存的数据
 */
- (void)requestHandleResultFromCache:(id _Nullable)cacheResult;

/**
 *  自定义UrlRequest
 *
 *  @return NSURLRequest
 */
- (NSURLRequest *)buildCustomUrlRequest;

#pragma mark - Cache

/**
 *  缓存路径 不推荐重写
 *
 *  @return NSString
 */
- (NSString *)cachePath;

/**
 *  缓存过期时间（默认-1 永远不过期）
 *
 *  @return NSTimeInterval
 */
- (NSTimeInterval)cacheExpireTimeInterval;

/**
 *  清理缓存回调block
 */
- (void)clearCacheCompletionBlock;

/**
 *  缓存需要忽略的参数
 *
 *  @return NSArray
 */
- (NSArray *)cacheFileNameIgnoreKeysForParameters;

#pragma mark - config

/**
 *  网络配置
 *
 *  @return TUNetworkConfig
 */
- (id<TUNetworkConfigProtocol>)requestConfig;

/**
 *  请求结果校验
 *
 *  @return BOOL
 */
- (BOOL)requestVerifyResult;

@end

NS_ASSUME_NONNULL_END
