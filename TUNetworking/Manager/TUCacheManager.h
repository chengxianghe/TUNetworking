//
//  TUCacheManager.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TUBaseRequest;

typedef void (^TUCacheReadCompletion)(NSError *error, id cacheResult);
typedef void (^TUCacheWriteCompletion)(NSError *error, NSString *cachePath);

@interface TUCacheManager : NSObject

/// 根据缓存路径取得缓存数据
+ (void)getCacheObjectWithCachePath:(NSString *)path completion:(TUCacheReadCompletion)completion;

/// 根据缓存路径存储缓存数据
+ (void)saveCacheObject:(id)object withCachePath:(NSString *)path completion:(TUCacheWriteCompletion)completion;

/// 取得某个请求的缓存
+ (void)getCacheForRequest:(TUBaseRequest *)request completion:(TUCacheReadCompletion)completion;

/// 缓存某个请求
+ (void)saveCacheForRequest:(TUBaseRequest *)request completion:(TUCacheWriteCompletion)completion;

/// 清除某个请求的缓存
+ (void)clearCacheForRequest:(TUBaseRequest *)request;

/// 清除所有缓存
+ (void)clearAllCacheWithCompletion:(void(^)())completion;

/// 获取单个缓存文件的大小,返回多少B
+ (CGFloat)getCacheSizeWithRequest:(TUBaseRequest *)request;

/// 获取所有缓存文件的大小,返回多少B
+ (void)getCacheSizeOfAllWithCompletion:(void(^)(CGFloat totalSize))completion;

/// 返回文件缓存的主目录
+ (NSString *)cacheBaseDirPath;

/// 返回下载文件缓存的主目录
+ (NSString *)cacheBaseDownloadDirPath;

+ (BOOL)checkDirPath:(NSString *)dirPath autoCreate:(BOOL)autoCreate;

@end
