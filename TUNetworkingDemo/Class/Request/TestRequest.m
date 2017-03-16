//
//  TestRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/20.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest

- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionCachePriority;
}

- (NSString *)requestProtocol {
    return @"http://";
}

- (NSString *)requestHost {
    return @"mobile.ximalaya.com";
}

- (NSString *)requestUrl {
    return @"/mobile/discovery/v1/recommends?channel=and-d3&includeActivity=true&scale=2";
}

- (NSDictionary *)requestParameters {
    return @{@"version" : @"4.3.26.2",
             @"device" : @"android",
             @"includeSpecial" : @"true",
             @"page" : @(_page),
             @"jjjj" : @"试试 中文"};
}


- (NSArray *)cacheFileNameIgnoreKeysForParameters {
    return @[@"device", @"includeSpecial"];
}

- (void)requestHandleResultFromCache:(id)cacheResult {
    NSLog(@"%s", __func__);
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
