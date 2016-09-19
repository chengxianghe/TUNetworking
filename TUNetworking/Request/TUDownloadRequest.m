//
//  TUDownloadRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/22.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUDownloadRequest.h"
#import "TUNetworkConfig.h"
#import "TUCacheManager.h"
#import "TURequestManager.h"

@interface TUDownloadRequest ()

@property (nonatomic, copy) _Nullable AFProgressBlock downloadProgressBlock;

@end

@implementation TUDownloadRequest

- (void)downloadWithCache:(TURequestCacheCompletion)cache
                 progress:(AFProgressBlock)downloadProgressBlock
                  success:(TURequestSuccess)success
                   failur:(TURequestFailur)failur {
    self.downloadProgressBlock = downloadProgressBlock;
    [super sendRequestWithCache:cache success:success failur:failur];
}

- (AFDownloadDestinationBlock)downloadDestinationBlock {
    AFDownloadDestinationBlock blcok = ^NSURL * _Nullable(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:[self cachePath]];
    };
    return blcok;
}

- (void)cancelRequest {
    NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)self.requestTask ;
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [self producingResumeData:resumeData];
    }];
}

- (void)producingResumeData:(NSData *)resumeData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [resumeData writeToFile:[self resumeDataPath] atomically:YES];
    });
}

- (NSData *)resumeData {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:[self resumeDataPath] options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        TULog(@"Error get resume data error:%@", error.description);
        return nil;
    } else {
        return data;
    }
}

- (NSString *)resumeDataPath {
    NSString *resumeDataPath = [[self cachePath] stringByAppendingPathExtension:@"_temp"];
    return resumeDataPath;
}

- (void)resume {
    if (self.requestTask.state != NSURLSessionTaskStateRunning) {
        [self.requestTask resume];
    }
}

- (void)suspend {
    if (self.requestTask.state == NSURLSessionTaskStateRunning) {
        [self.requestTask suspend];
    }
}

- (NSString *)cachePath {
    NSString *basePath = [TUCacheManager cacheBaseDownloadDirPath];
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@", basePath, [self class]];
    
    [TUCacheManager checkDirPath:dirPath autoCreate:YES];
    
    NSString *cacheFileName = [[self requestUrl] lastPathComponent];
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@", dirPath, cacheFileName];
    return cachePath;
}

@end
