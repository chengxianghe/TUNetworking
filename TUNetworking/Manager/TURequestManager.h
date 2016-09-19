//
//  TURequestManager.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TUBaseRequest;

@interface TURequestManager : NSObject

+ (instancetype)manager;

+ (NSMutableDictionary *)buildRequestHeader:(TUBaseRequest *)request;

+ (NSMutableDictionary *)buildRequestParameters:(TUBaseRequest *)request;

+ (NSString *)buildRequestUrl:(TUBaseRequest *)request;

- (void)sendRequest:(TUBaseRequest *)request;

- (void)cancelRequest:(TUBaseRequest *)request;

- (void)cancelAllRequests;

@end
