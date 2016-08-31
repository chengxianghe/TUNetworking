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

- (void)sendRequest:(TUBaseRequest *)request;

- (void)cancelRequest:(TUBaseRequest *)request;

- (void)cancelAllRequests;

/**
 *  是否开启 Debug Log 默认开启 YES
 */
- (void)setDebugLog:(BOOL)debugLog;

@end
