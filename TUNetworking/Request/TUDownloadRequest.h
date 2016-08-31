//
//  TUDownloadRequest.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/22.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  下载请求 支持断点续传
 */
@interface TUDownloadRequest : TUBaseRequest

- (void)sendRequestWithSuccess:(TURequestSuccess _Nullable)success
                        failur:(TURequestFailur _Nullable)failur __attribute__((unavailable("use [-downloadWithCache:progress:success:failur:]")));

- (void)sendRequestWithCache:(TURequestCacheCompletion _Nullable)cache
                     success:(TURequestSuccess _Nullable)success
                      failur:(TURequestFailur _Nullable)failur __attribute__((unavailable("use [-downloadWithCache:progress:success:failur:]")));

/**
 *  发送请求（缓存）
 *
 *  @param cache    缓存读取完的回调
 *  @param success  成功的回调
 *  @param failur   失败的回调
 */
- (void)downloadWithCache:(TURequestCacheCompletion _Nullable)cache
                 progress:(AFProgressBlock)downloadProgressBlock
                  success:(TURequestSuccess _Nullable)success
                   failur:(TURequestFailur _Nullable)failur;

/**
 *  继续下载
 */
- (void)resume;

/**
 *  暂停下载
 */
- (void)suspend;

@end
NS_ASSUME_NONNULL_END