//
//  TUBaseRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBaseRequest.h"
#import "TUNetworkConfig.h"
#import "TUCacheManager.h"
#import "TURequestManager.h"
#import "TUNetworkHelper.h"

@implementation TUBaseRequest

- (NSString *)appProtocol {
    if ([[self requestConfig] respondsToSelector:@selector(requestProtocol)]) {
        return [[self requestConfig] requestProtocol];
    } else {
        return [[TUNetworkConfig config] requestProtocol];
    }
}

- (NSString *)appHost {
    if ([[self requestConfig] respondsToSelector:@selector(requestHost)]) {
        return [[self requestConfig] requestHost];
    } else {
        return [[TUNetworkConfig config] requestHost];
    }
}

- (NSTimeInterval)requestTimeoutInterval {
    if ([[self requestConfig] respondsToSelector:@selector(requestTimeoutInterval)]) {
        return [[self requestConfig] requestTimeoutInterval];
    } else {
        return [[TUNetworkConfig config] requestTimeoutInterval];
    }
}

- (NSTimeInterval)cacheExpireTimeInterval {
    return -1;
}

- (TURequestMethod)requestMethod {
    if ([[self requestConfig] respondsToSelector:@selector(requestMethod)]) {
        return [[self requestConfig] requestMethod];
    } else {
        return [[TUNetworkConfig config] requestMethod];
    }
}

- (TURequestSerializerType)requestSerializerType {
    if ([[self requestConfig] respondsToSelector:@selector(requestSerializerType)]) {
        return [[self requestConfig] requestSerializerType];
    } else {
        return [[TUNetworkConfig config] requestSerializerType];
    }
}

- (TURequestPublicParametersType)requestPublicParametersType {
    if ([[self requestConfig] respondsToSelector:@selector(requestPublicParametersType)]) {
        return [[self requestConfig] requestPublicParametersType];
    } else {
        return [[TUNetworkConfig config] requestPublicParametersType];
    }
}

- (AFSecurityPolicy *)requestSecurityPolicy {
    if ([[self requestConfig] respondsToSelector:@selector(requestSecurityPolicy)]) {
        return [[self requestConfig] requestSecurityPolicy];
    } else {
        return [[TUNetworkConfig config] requestSecurityPolicy];
    }
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSString *)requestUrl {
    return nil;
}

- (NSDictionary *)requestParameters {
    return nil;
}

- (NSArray *)cacheFileNameIgnoreKeysForParameters {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (void)clearCompletionBlock {
    self.successBlock = nil;
    self.failurBlock = nil;
}

- (void)clearCacheCompletionBlock {
    self.cacheCompletionBlcok = nil;
}

- (void)sendRequestWithSuccess:(TURequestSuccess)success
                        failur:(TURequestFailur)failur {
    [self sendRequestWithCache:nil success:success failur:failur];
}

- (void)sendRequestWithCache:(TURequestCacheCompletion)cache
                     success:(TURequestSuccess)success
                      failur:(TURequestFailur)failur {
    self.successBlock = success;
    self.failurBlock = failur;
    self.cacheCompletionBlcok = cache;
    [[TURequestManager manager] sendRequest:self];
}

- (void)cancelRequest {
    [[TURequestManager manager] cancelRequest:self];
}

- (void)requestHandleResult {
    
}

- (void)requestHandleResultFromCache:(id)cacheResult {
    
}

#pragma mark - Cache

- (NSString *)cachePath {
    NSString *basePath = [TUCacheManager cacheBaseDirPath];
    
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@/%@", basePath, [[self requestConfig] configUserId], [self class]];
    
    NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:[TUNetworkHelper buildRequestParameters:self]];
    NSArray *ignoreKeys = [self cacheFileNameIgnoreKeysForParameters];
    if (ignoreKeys.count) {
        [mudict removeObjectsForKeys:ignoreKeys];
    }
    
    NSString *requestInfo = [NSString stringWithFormat:@"Class:%@ Argument:%@ Url:%@", [self class], mudict,[TUNetworkHelper buildRequestUrl:self]];
    
    NSString *cacheFileName = [TUNetworkHelper md5StringFromString:requestInfo];
    
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@.json", dirPath, cacheFileName];
    
    return cachePath;
}

#pragma mark - Config

- (id<TUNetworkConfigProtocol>)requestConfig {
    return [TUNetworkConfig config];
}

- (BOOL)requestVerifyResult {
    return [[self requestConfig] requestVerifyResult:self.responseObject];
}

- (NSString *)description {
    NSURLRequest *request = [[self requestTask] currentRequest];
    return [NSString stringWithFormat:@"<%@: %p, url: %@, parameters: %@, NSURLRequest:%@, allHTTPHeaderFields: %@, HTTPBody: %@>", NSStringFromClass([self class]), self, [TUNetworkHelper buildRequestUrl:self], [TUNetworkHelper buildRequestParameters:self], request, [request allHTTPHeaderFields], [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]];
}

@end
