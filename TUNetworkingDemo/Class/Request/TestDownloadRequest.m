//
//  TestDownloadRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TestDownloadRequest.h"
#import "TUCacheManager.h"
#import "TestNetConfig.h"

@implementation TestDownloadRequest

- (id<TUNetworkConfigProtocol>)requestConfig {
    return [TestNetConfig config];
}

- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionCacheSaveFlow;
}

- (NSString *)requestUrl {
    return @"http://images0.cnblogs.com/blog2015/717809/201508/241602591241789.gif";
//    return @"http://krtv.qiniudn.com/150522nextapp";
}

- (void)requestHandleResultFromCache:(id)cacheResult {
    NSLog(@"%s", __func__);
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
