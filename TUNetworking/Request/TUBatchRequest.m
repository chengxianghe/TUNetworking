//
//  TUBatchRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/23.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TUBatchRequest.h"
#import <objc/runtime.h>
#import "TURequestManager.h"

// 默认同时开启最多3个上传请求
#define kDefaultRequestMaxNum (3)

// 默认的单个请求的默认超时时间
#define kDefauletMaxTime (60)

static const void *kBatchIndexKey; // BatchIndex

@interface TUBaseRequest (Batch)

@property (nonatomic, assign) NSInteger batchIndex;

@end

@implementation TUBaseRequest (Batch)

- (NSInteger)batchIndex {
    NSNumber *scaleValue = objc_getAssociatedObject(self, &kBatchIndexKey);
    return scaleValue.integerValue;
}

- (void)setBatchIndex:(NSInteger)batchIndex {
    objc_setAssociatedObject(self, &kBatchIndexKey, @(batchIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface TUBatchRequest ()

//外部参数
@property (nonatomic, assign) NSInteger totalCount; // 请求组请求个数
@property (nonatomic, assign) TUBatchRequestMode mode; // 请求模式
@property (nonatomic,   copy) TUBatchRequestCompletionBlock completion;
@property (nonatomic,   copy) TUBatchRequestProgressBlock progress;
@property (nonatomic,   copy) TUBatchRequestOneProgressBlock oneProgress;
@property (nonatomic, assign) NSTimeInterval maxTime;// 最长时间限制

// 内部参数
@property (nonatomic, strong) NSMutableArray *requestArray; // 已经发起的请求
@property (nonatomic, strong) NSMutableArray *requestReadyArray; // 准备发起的请求
@property (nonatomic, strong) NSMutableArray *resultArray; // 完成的请求
@property (nonatomic, assign) NSInteger maxNum; // 同时最大并发数 默认 kDefaultUploadMaxNum
@property (nonatomic, assign) BOOL isEnd; // 是否已经结束请求

@end

@implementation TUBatchRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestArray = [NSMutableArray array];
        self.resultArray = [NSMutableArray array];
        self.requestReadyArray = [NSMutableArray array];
        self.maxNum = kDefaultRequestMaxNum;
        self.maxTime = kDefauletMaxTime;
        self.isEnd = NO;
    }
    return self;
}

//MARK: - Public

- (void)cancelRequest {
    // 先取消 结束回调
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endRequests) object:nil];
    self.isEnd = YES;
    
    for (TUBaseRequest *request in self.requestArray) {
        [self cancelOneRequest:request];
    }
    if (self.completion) {
        self.completion(self.resultArray, [NSError errorWithDomain:@"Error: BatchRequest was cancelled." code:-1 userInfo:nil]);
    }
    self.completion = nil;
    self.progress = nil;
//    self.oneProgress = nil;
}

+ (instancetype)sendRequests:(NSArray<__kindof TUBaseRequest *> *)requests requestMode:(TUBatchRequestMode)mode progress:(TUBatchRequestProgressBlock)progress completion:(TUBatchRequestCompletionBlock)completion {
    TUBatchRequest *request = [[TUBatchRequest alloc] init];
    [request sendRequests:requests requestMode:mode maxTime:0 progress:progress oneProgress:nil completion:completion];
    return request;
}

- (void)sendRequests:(NSArray<__kindof TUBaseRequest *> *)requests requestMode:(TUBatchRequestMode)mode maxTime:(NSTimeInterval)maxTime progress:(TUBatchRequestProgressBlock)progress oneProgress:(TUBatchRequestOneProgressBlock)oneProgress completion:(TUBatchRequestCompletionBlock)completion {
    
    [self.requestArray removeAllObjects];
    [self.requestReadyArray removeAllObjects];
    [self.resultArray removeAllObjects];
    
    self.completion = completion;
    self.progress = progress;
    self.mode = mode;
    self.totalCount = requests.count;
    if (maxTime != 0) {
        self.maxTime = maxTime;
    }
    self.isEnd = NO;
    
    // 根据网络环境 决定 同时上传数量
    if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        self.maxNum = kDefaultRequestMaxNum;
    } else {
        self.maxNum = 1;
    }
    
    NSInteger i = 0;
    for (TUBaseRequest *request in requests) {
        request.batchIndex = i++;
        [self addRequest:request];
        if (maxTime == 0) {
            self.maxTime += [request requestTimeoutInterval];
        }
    }
    
    // 先回调一下progress
    if (self.progress) {
        self.progress(self.totalCount, self.resultArray.count);
    }
    
    // 定时回调endUpload
    [self performSelector:@selector(endRequests) withObject:nil afterDelay:self.maxTime];
}

//MARK: - Private

- (void)cancelOneRequest:(TUBaseRequest *)request {
    [request cancelRequest];
    request = nil;
}

- (void)removeRequest:(TUBaseRequest *)request {
    [self.requestArray removeObject:request];
    [self cancelOneRequest:request];
    
    if (self.requestReadyArray.count > 0 && self.requestArray.count < self.maxNum) {
        TUBaseRequest *req = [self.requestReadyArray firstObject];
        [self.requestArray addObject:req];
        [self startRequest:req];
        [self.requestReadyArray removeObject:req];
    }
}

- (void)addRequest:(TUBaseRequest *)request {
    if (request != nil) {
        if (self.requestArray.count < self.maxNum) {
            [self.requestArray addObject:request];
            [self startRequest:request];
        } else {
            [self.requestReadyArray addObject:request];
        }
    }
}

- (void)startRequest:(TUBaseRequest *)request {
    __weak typeof(self) weakSelf = self;
    NSLog(@"*********请求组正在请求的index:%ld ....", request.batchIndex);
    [request sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        [weakSelf checkResult:request error:nil];
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        if (weakSelf.mode == TUBatchRequestModeStrict) {
            [weakSelf cancelRequest];
        } else {
            [weakSelf checkResult:request error:error];
        }
    }];
}

- (void)checkResult:(TUBaseRequest *)request error:(NSError *)error {
    if (self.isEnd) {
        return;
    }
    
    [self.resultArray addObject:request];
    [self removeRequest:request];
    
    // 单个请求完成回调
    if (self.oneProgress) {
        self.oneProgress(request, error);
    }
    
    // 进度回调
    if (self.progress) {
        self.progress(self.totalCount, self.resultArray.count);
    }
    
    if (self.resultArray.count == self.totalCount) {
        [self endRequests];
    }
}

- (void)endRequests {
    // 全部完成
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endRequests) object:nil];
    
    // 排序
    [self.resultArray sortUsingComparator:^NSComparisonResult(TUBaseRequest *obj1, TUBaseRequest *obj2) {
        // 从小到大
        return obj1.batchIndex > obj2.batchIndex;
    }];
    
    if (self.completion) {
        self.completion(self.resultArray, nil);
    }
    
    [self cancelRequest];
}

@end
