//
//  TUUploadRequest.h
//  MissLi
//
//  Created by chengxianghe on 16/7/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBaseRequest.h"

/**
 *  上传请求 默认无缓存 默认请求方式POST
 */
@interface TUUploadRequest : TUBaseRequest

/**
 *  POST传送文件文件
 */
@property (nonatomic, readonly, nullable) AFConstructingBlock constructingBodyBlock;

/**
 *  POST传送文件Data(自定义Request)
 */
@property (nonatomic, readonly, nullable) NSData * fileData;

/**
 *  POST传送文件URL(自定义Request)
 */
@property (nonatomic, readonly, nullable) NSURL * fileURL;

/**
 *  当需要上传时，获得上传进度的回调
 */
@property (nonatomic, readonly, nullable) AFProgressBlock uploadProgressBlock;

- (void)sendRequestWithSuccess:(nullable TURequestSuccess)success
                        failur:(nullable TURequestFailur)failur __attribute__((unavailable("use [-uploadWithConstructingBody:progress:success:failur:]")));

- (void)sendRequestWithCache:(nullable TURequestCacheCompletion)cache
                     success:(nullable TURequestSuccess)success
                      failur:(nullable TURequestFailur)failur __attribute__((unavailable("use [-uploadWithConstructingBody:progress:success:failur:]")));



@end
