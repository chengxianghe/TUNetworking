//
//  TestDouBanBaseRequest.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/16.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TestDouBanBaseRequest.h"
#import "TestDouBanConfig.h"

@implementation TestDouBanBaseRequest

- (id<TUNetworkConfigProtocol>)requestConfig {
    return [TestDouBanConfig config];
}

@end
