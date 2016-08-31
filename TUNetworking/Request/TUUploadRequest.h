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
@property (nonatomic, readonly) AFConstructingBlock _Nullable constructingBodyBlock;

/**
 *  POST传送文件Data(自定义Request)
 */
@property (nonatomic, readonly) NSData * _Nullable fileData;

/**
 *  POST传送文件URL(自定义Request)
 */
@property (nonatomic, readonly) NSURL * _Nullable fileURL;

/**
 *  当需要上传时，获得上传进度的回调
 */
@property (nonatomic, readonly) AFProgressBlock _Nullable uploadProgressBlock;

- (void)sendRequestWithSuccess:(TURequestSuccess _Nullable)success
                        failur:(TURequestFailur _Nullable)failur __attribute__((unavailable("use [-uploadWithConstructingBody:progress:success:failur:]")));

- (void)sendRequestWithCache:(TURequestCacheCompletion _Nullable)cache
                     success:(TURequestSuccess _Nullable)success
                      failur:(TURequestFailur _Nullable)failur __attribute__((unavailable("use [-uploadWithConstructingBody:progress:success:failur:]")));

/**
 *  上传请求 POST
 *
 *  @param constructingBody 上传的数据
 *  @param uploadProgress   上传进度
 *  @param success          成功的回调
 *  @param failur           失败的回调
 */
- (void)uploadWithConstructingBody:(AFConstructingBlock _Nullable)constructingBody
                          progress:(AFProgressBlock _Nullable)uploadProgress
                           success:(TURequestSuccess _Nullable)success
                            failur:(TURequestFailur _Nullable)failur;
/**
 *  上传请求 POST (自定义request)
 *
 *  @param fileData         上传的数据
 *  @param uploadProgress   上传进度
 *  @param success          成功的回调
 *  @param failur           失败的回调
 */
- (void)uploadCustomRequestWithFileData:(NSData * _Nullable)fileData
                               progress:(AFProgressBlock _Nullable)uploadProgress
                                success:(TURequestSuccess _Nullable)success
                                 failur:(TURequestFailur _Nullable)failur;
/**
 *  上传请求 POST (自定义request)
 *
 *  @param fileURL          上传的文件URL
 *  @param uploadProgress   上传进度
 *  @param success          成功的回调
 *  @param failur           失败的回调
 */
- (void)uploadCustomRequestWithFileURL:(NSURL * _Nullable)fileURL
                              progress:(AFProgressBlock _Nullable)uploadProgress
                               success:(TURequestSuccess _Nullable)success
                                failur:(TURequestFailur _Nullable)failur;

@end
