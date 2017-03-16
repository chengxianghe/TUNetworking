//
//  TestDouBanConfig.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/16.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TestDouBanConfig.h"

@interface TestDouBanConfig ()

/// 用户的uid
@property (nonatomic, copy) NSString *userId;
/// 请求的公共参数
@property (nonatomic, strong) NSDictionary *publicParameters;

@end

@implementation TestDouBanConfig

+ (instancetype)config {
    static TestDouBanConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)updateUserId:(NSString *)userId {
    self.userId = userId;
}

- (void)updatePublicParameters:(NSDictionary *)publicParameters {
    self.publicParameters = publicParameters;
}

- (NSString *)configUserId {
    if (self.userId) {
        return self.userId;
    }
    return @"0";
}

- (NSString *)requestProtocol {
    return @"https://";
}

- (NSString *)requestHost {
    return @"api.douban.com";
}

- (AFSecurityPolicy *)requestSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    [securityPolicy setValidatesDomainName:NO];
    
    return securityPolicy;
}

/// 请求的超时时间
- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

/// Http请求的方法
- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

/// 请求的SerializerType
- (TURequestSerializerType)requestSerializerType {
    return TURequestSerializerTypeJSON;
}

/// 请求公参
- (NSDictionary *)requestPublicParameters {
    return @{
             @"alt":@"json",
             @"apikey":@"02646d3fb69a52ff072d47bf23cef8fd",
             @"app_name":@"radio_iphone",
             @"client":@"s:mobile|y:iOS 10.2|f:115|d:b88146214e19b8a8244c9bc0e2789da68955234d|e:iPhone7,1|m:appstore",
             @"douban_udid":@"b635779c65b816b13b330b68921c0f8edc049590",
             @"udid":@"b88146214e19b8a8244c9bc0e2789da68955234d",
             @"version":@"115",
             };
}

/// 请求公参的位置
- (TURequestPublicParametersType)requestPublicParametersType {
    return TURequestPublicParametersTypeBody;
}

/// 请求校验
- (BOOL)requestVerifyResult:(id)result {
    if (result) {
        return YES;
    }
    return NO;
}

@end
