//
//  TestUploadRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/15.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TestDouBanUploadRequest.h"
#import "TestDouBanConfig.h"

@implementation TestDouBanUploadRequest

- (id<TUNetworkConfigProtocol>)requestConfig {
    return [TestDouBanConfig config];
}

- (TURequestMethod)requestMethod {
    return TURequestMethodPut;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Authorization":[@"Bearer " stringByAppendingString:[TestDouBanConfig config].token]};
}

- (NSString *)requestUrl {
    return @"/v2/lifestream/user/~me";
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
