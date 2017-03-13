//
//  TUNetworkConfig.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUNetworkDefine.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
@import AFNetworking;
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol TUNetworkConfigProtocol <NSObject>

@required

+ (nonnull id<TUNetworkConfigProtocol>)config;

/// 用户的uid
- (nonnull NSString *)configUserId;

/// 请求的公共参数
- (nullable NSDictionary *)requestPublicParameters;

/// 校验请求结果
- (BOOL)requestVerifyResult:(nonnull id)result;

@optional
/// 请求的protocol
- (nullable NSString *)requestProtocol;

/// 请求的Host
- (nullable NSString *)requestHost;

/// 请求的超时时间
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的安全选项
- (nullable AFSecurityPolicy *)requestSecurityPolicy;

/// Http请求的方法
- (TURequestMethod)requestMethod;

/// 请求的SerializerType
- (TURequestSerializerType)requestSerializerType;

/// 请求公参的位置
- (TURequestPublicParametersType)requestPublicParametersType;

@end

@interface TUNetworkConfig : NSObject <TUNetworkConfigProtocol>

@property (nonatomic, copy, nonnull) NSString *userId; ///< 用户的uid
@property (nonatomic, strong, nullable) NSDictionary *publicParameters; ///< 请求的公共参数

+ (nonnull instancetype)config;

- (nonnull NSString *)configUserId;

/// 请求的protocol
- (nullable NSString *)requestProtocol;

/// 请求的Host
- (nullable NSString *)requestHost;

/// 请求的超时时间
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的安全选项
- (nullable AFSecurityPolicy *)requestSecurityPolicy;

/// Http请求的方法
- (TURequestMethod)requestMethod;

/// 请求的SerializerType
- (TURequestSerializerType)requestSerializerType;

/// 请求公参
- (nullable NSDictionary *)requestPublicParameters;

/// 请求公参的位置
- (TURequestPublicParametersType)requestPublicParametersType;

/// 校验请求结果
- (BOOL)requestVerifyResult:(nullable id)result;

@end

NS_ASSUME_NONNULL_END
