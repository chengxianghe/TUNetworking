//
//  TestNetConfig.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/20.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TestNetConfig.h"

@interface TestNetConfig ()

/// 用户的uid
@property (nonatomic, copy) NSString *userId;
/// 请求的公共参数
@property (nonatomic, strong) NSDictionary *publicParameters;

@end

@implementation TestNetConfig

+ (instancetype)config {
    static TestNetConfig *sharedInstance = nil;
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
    return self.userId;
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
    return TURequestSerializerTypeHTTP;
}

/// 请求公参
- (NSDictionary *)requestPublicParameters {
    return nil;
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
