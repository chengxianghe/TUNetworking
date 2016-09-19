//
//  TURequestManager.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TURequestManager.h"
#import "TUBaseRequest.h"
#import "TUDownloadRequest.h"
#import "TUUploadRequest.h"
#import "TUNetworkHelper.h"
#import "TUCacheManager.h"

@interface TUDownloadRequest ()

/**
 *  下载文件所在地址
 *
 *  @return AFDownloadDestinationBlock
 */
- (AFDownloadDestinationBlock)downloadDestinationBlock;

/**
 *  下载文件进度
 *
 *  @return AFProgressBlock
 */
- (AFProgressBlock)downloadProgressBlock;

/**
 *  断点下载时存储的文件信息
 */
- (NSData * __nullable)resumeData;

@end

@implementation TURequestManager {
    AFHTTPSessionManager *_sessionManager;
    NSMutableDictionary *_requestsRecord;
}

+ (TURequestManager *)manager {
    static TURequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 4;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                     @"application/json",
                                                                     @"text/json",
                                                                     @"text/javascript",
                                                                     @"text/html",
                                                                     @"text/plain",
                                                                     nil];
    }
    return self;
}

- (void)sendRequest:(TUBaseRequest *)request {
    // check cache option
    TURequestCacheOption cacheOption = [request cacheOption];
    
    if (cacheOption == TURequestCacheOptionCacheOnly || cacheOption == TURequestCacheOptionCachePriority || cacheOption == TURequestCacheOptionCacheSaveFlow) {
        // get cache
        [TUCacheManager getCacheForRequest:request completion:^(NSError *error, id cacheResult) {
            [self handleCacheRequestResultCompletion:request error:error cacheResult:cacheResult];
        }];
        
        if (cacheOption == TURequestCacheOptionCacheOnly || cacheOption == TURequestCacheOptionCacheSaveFlow) {
            return;
        }
    }
    
    [self sendRequestToNet:request];
}

- (void)sendRequestToNet:(TUBaseRequest *)request {
    TURequestMethod method = [request requestMethod];
    NSString *url = [TURequestManager buildRequestUrl:request];
    NSDictionary *param = [TURequestManager buildRequestParameters:request];
    
    if (request.requestSerializerType == TURequestSerializerTypeHTTP) {
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == TURequestSerializerTypeJSON) {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    _sessionManager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    // security
    _sessionManager.securityPolicy = [request requestSecurityPolicy];
    
    // custom request
    NSURLRequest *customUrlRequest = [request buildCustomUrlRequest];
    if (customUrlRequest) {
        AFProgressBlock downloadProgressBlock = nil;
        if ([request isKindOfClass:[TUDownloadRequest class]]) {
            downloadProgressBlock = [(TUDownloadRequest *)request downloadProgressBlock];
        }
        
        AFProgressBlock uploadProgressBlock = nil;
        NSData *fileData = nil;
        NSURL *fileURL = nil;

        if ([request isKindOfClass:[TUUploadRequest class]]) {
            downloadProgressBlock = [(TUUploadRequest *)request uploadProgressBlock];
            fileData = [(TUUploadRequest *)request fileData];
            fileURL = [(TUUploadRequest *)request fileURL];
        }
        
        if (fileData != nil) {
            request.requestTask = [_sessionManager uploadTaskWithRequest:customUrlRequest fromData:fileData progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    [self handleRequestResultSuccess:request.requestTask responseObject:responseObject];
                } else {
                    [self handleRequestResultFailur:request.requestTask error:error];
                }
            }];
        } else if (fileURL != nil) {
            request.requestTask = [_sessionManager uploadTaskWithRequest:customUrlRequest fromFile:fileURL progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    [self handleRequestResultSuccess:request.requestTask responseObject:responseObject];
                } else {
                    [self handleRequestResultFailur:request.requestTask error:error];
                }
            }];
        } else {
            request.requestTask = [_sessionManager dataTaskWithRequest:customUrlRequest uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    [self handleRequestResultSuccess:request.requestTask responseObject:responseObject];
                } else {
                    [self handleRequestResultFailur:request.requestTask error:error];
                }
            }];
        }
        
        [request.requestTask resume];
    } else {
        // add custom value to HTTPHeaderField
        NSDictionary *headerFieldValueDictionary = [TURequestManager buildRequestHeader:request];
        if (headerFieldValueDictionary != nil && [[headerFieldValueDictionary allKeys] count]) {
            for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
                id value = headerFieldValueDictionary[httpHeaderField];
                if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                    [_sessionManager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
                } else {
                    TULog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
                }
            }
        }
        
        if (method == TURequestMethodGet) {
            AFProgressBlock downloadProgressBlock = nil;
            AFDownloadDestinationBlock downloadDestinationBlock = nil;
            if ([request isKindOfClass:[TUDownloadRequest class]]) {
                downloadProgressBlock = [(TUDownloadRequest *)request downloadProgressBlock];
                downloadDestinationBlock = [(TUDownloadRequest *)request downloadDestinationBlock];
            }
            
            if (downloadDestinationBlock) {
                // add parameters to URL;
                NSString *filteredUrl = [TUNetworkHelper urlStringWithOriginUrlString:url appendParameters:param];
                NSURLRequest *requestUrl = [NSURLRequest requestWithURL:[NSURL URLWithString:filteredUrl]];
                NSData *resumeData = [(TUDownloadRequest *)request resumeData];
                
                if (resumeData.length) {
                    request.requestTask = [_sessionManager downloadTaskWithResumeData:resumeData progress:downloadProgressBlock destination:downloadDestinationBlock completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        [self handleDownloadRequest:(TUDownloadRequest *)request response:response filePath:filePath error:error
                         ];
                    }];
                } else {
                    request.requestTask = [_sessionManager downloadTaskWithRequest:requestUrl progress:downloadProgressBlock destination:downloadDestinationBlock completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        [self handleDownloadRequest:(TUDownloadRequest *)request response:response filePath:filePath error:error];
                    }];
                }
                
                [request.requestTask resume];
            } else {
                request.requestTask = [_sessionManager GET:url parameters:param progress:downloadProgressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultSuccess:task responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultFailur:task error:error];
                }];
            }
        } else if (method == TURequestMethodPost) {
            
            AFConstructingBlock constructingBlock = nil;
            AFProgressBlock uploadProgressBlock = nil;
            if ([request isKindOfClass:[TUUploadRequest class]]) {
                constructingBlock = [(TUUploadRequest *)request constructingBodyBlock];
                uploadProgressBlock = [(TUUploadRequest *)request uploadProgressBlock];
            }
            
            if (constructingBlock != nil) {
                request.requestTask = [_sessionManager POST:url parameters:param constructingBodyWithBlock:constructingBlock progress:uploadProgressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultSuccess:task responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultFailur:task error:error];
                }];
            } else {
                request.requestTask = [_sessionManager POST:url parameters:param progress:uploadProgressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleRequestResultSuccess:task responseObject:responseObject];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleRequestResultFailur:task error:error];
                }];
            }
        } else if (method == TURequestMethodHead) {
            request.requestTask = [_sessionManager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
                [self handleRequestResultSuccess:task responseObject:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResultFailur:task error:error];
            }];
        } else if (method == TURequestMethodPut) {
            request.requestTask = [_sessionManager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResultSuccess:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResultFailur:task error:error];
            }];
        } else if (method == TURequestMethodDelete) {
            request.requestTask = [_sessionManager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResultSuccess:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResultFailur:task error:error];
            }];
        } else if (method == TURequestMethodPatch) {
            request.requestTask = [_sessionManager PATCH:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleRequestResultSuccess:task responseObject:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestResultFailur:task error:error];
            }];
        } else {
            TULog(@"Error, Unsupport method type");
            return;
        }
    }
    
    // the priority of the task, NSURLSessionTaskPriorityDefault not support
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        switch (request.requestPriority) {
            case TURequestPriorityHigh:
                request.requestTask.priority = 1.0;
                break;
            case TURequestPriorityLow:
                request.requestTask.priority = 0.1;
                break;
            case TURequestPriorityDefault:
            default:
                request.requestTask.priority = 0.5;
                break;
        }
    }
    
    TULog(@"Sent Request: %@", request);
    [self addTaskWithRequest:request];
}

- (void)cancelRequest:(TUBaseRequest *)request {
    [request.requestTask cancel];
    [self removeTask:request.requestTask];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        TUBaseRequest *request = copyRecord[key];
        [request cancelRequest];
    }
}

- (void)handleDownloadRequest:(TUDownloadRequest * _Nonnull)request response:(NSURLResponse *)response filePath:(NSURL *)filePath error:(NSError *)error {
    TULog(@"Finished Download For Request: %@ filePath:%@", NSStringFromClass([request class]), filePath);
    if (error) {
        [self handleRequestResultFailur:request.requestTask error:error];
    } else {
        [self handleRequestResultSuccess:request.requestTask responseObject:response];
    }
}

- (void)handleCacheRequestResultCompletion:(TUBaseRequest * _Nonnull)request error:(NSError *)error cacheResult:(id  _Nullable)cacheResult {
    TULog(@"Finished Get Cache For Request: %@", NSStringFromClass([request class]));
    [request requestHandleResultFromCache:cacheResult];
    
    if (request.cacheCompletionBlcok) {
        request.cacheCompletionBlcok(request, cacheResult, error);
    }
    [request clearCacheCompletionBlock];
    
    if ([request cacheOption] == TURequestCacheOptionCacheSaveFlow && error) {
        [self sendRequestToNet:request];
    }
}

- (void)handleRequestResultSuccess:(NSURLSessionTask * _Nonnull)task responseObject:(id  _Nullable)responseObject {
    NSString *key = [self requestHashKey:task];
    TUBaseRequest *request = _requestsRecord[key];
    TULog(@"Succeed Finished Request: %@", NSStringFromClass([request class]));
    
    if (!request) {
        return;
    }
    
    request.responseObject = responseObject;
    [request requestHandleResult];
    
    BOOL isRealSuccess = [request requestVerifyResult];
    
    if (isRealSuccess) {
        if (request.successBlock) {
            request.successBlock(request, responseObject);
        }
        TURequestCacheOption cacheOption = [request cacheOption];
        if (cacheOption == TURequestCacheOptionCachePriority || cacheOption == TURequestCacheOptionRefreshPriority || cacheOption == TURequestCacheOptionCacheSaveFlow) {
            [TUCacheManager saveCacheForRequest:request completion:^(NSError *error, NSString *cachePath) {
                if (error) {
                    TULog(@"Save Cache Error:%@!", error.description);
                } else {
                    TULog(@"Succeed Save Cache For Request:%@ path:%@", NSStringFromClass([request class]), cachePath);
                }
            }];
        }
    } else {
        if (request.failurBlock) {
            request.failurBlock(request, [NSError errorWithDomain:@"请求结果校验失败！" code:-1 userInfo:responseObject]);
        }
        if ([request cacheOption] == TURequestCacheOptionRefreshPriority) {
            [TUCacheManager getCacheForRequest:request completion:^(NSError *error, id cacheResult) {
                [self handleCacheRequestResultCompletion:request error:error cacheResult:cacheResult];
            }];
        }
    }
    [self removeTask:task];
    [request clearCompletionBlock];
}

- (void)handleRequestResultFailur:(NSURLSessionTask * _Nullable)task error:(NSError * _Nonnull)error {
    NSString *key = [self requestHashKey:task];
    TUBaseRequest *request = _requestsRecord[key];
    TULog(@"Failed Finished Request: %@", NSStringFromClass([request class]));
    if (!request) {
        return;
    }
    
    [request requestHandleResult];
    
    if (request.failurBlock) {
        request.failurBlock(request, error);
    }
    
    if ([request cacheOption] == TURequestCacheOptionRefreshPriority) {
        [TUCacheManager getCacheForRequest:request completion:^(NSError *error, id cacheResult) {
            [self handleCacheRequestResultCompletion:request error:error cacheResult:cacheResult];
        }];
    }
    
    [self removeTask:task];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(NSURLSessionTask * _Nullable)task {
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
    return key;
}

- (void)addTaskWithRequest:(TUBaseRequest *)request {
    if (request.requestTask != nil) {
        NSString *key = [self requestHashKey:request.requestTask];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeTask:(NSURLSessionTask * _Nullable)task {
    NSString *key = [self requestHashKey:task];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
        TULog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
    }
}

#pragma mark - tools build URL

+ (NSMutableDictionary *)buildRequestHeader:(TUBaseRequest *)request {
    NSDictionary *param = [request requestHeaderFieldValueDictionary];
    NSMutableDictionary *mutiDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([request requestPublicParametersType] == TURequestPublicParametersTypeHeader) {
        [mutiDict setValuesForKeysWithDictionary:[[request requestConfig] requestPublicParameters]];
    }
    
    [mutiDict setValuesForKeysWithDictionary:param];
    return mutiDict;
}

+ (NSMutableDictionary *)buildRequestParameters:(TUBaseRequest *)request {
    NSDictionary *param = [request requestParameters];
    NSMutableDictionary *mutiDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([request requestPublicParametersType] == TURequestPublicParametersTypeBody) {
        [mutiDict setValuesForKeysWithDictionary:[[request requestConfig] requestPublicParameters]];
    }
    
    [mutiDict setValuesForKeysWithDictionary:param];
    return mutiDict;
}

+ (NSString *)buildRequestUrl:(TUBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        if ([request requestPublicParametersType] == TURequestPublicParametersTypeUrl) {
            detailUrl = [TUNetworkHelper urlStringWithOriginUrlString:detailUrl appendParameters:[[request requestConfig] requestPublicParameters]];
        }
        return detailUrl;
    }
    
    NSMutableString *baseUrl = [NSMutableString string];
    
    if ([request appProtocol].length > 0) {
        [baseUrl appendString:[request appProtocol]];
    }
    if ([request appHost].length > 0) {
        [baseUrl appendString:[request appHost]];
    }
    if ([request requestUrl].length > 0) {
        [baseUrl appendString:[request requestUrl]];
    }
    if ([request requestPublicParametersType] == TURequestPublicParametersTypeUrl) {
        baseUrl = (NSMutableString *)[TUNetworkHelper urlStringWithOriginUrlString:baseUrl appendParameters:[[request requestConfig] requestPublicParameters]];
    }
    
    return baseUrl;
}


@end
