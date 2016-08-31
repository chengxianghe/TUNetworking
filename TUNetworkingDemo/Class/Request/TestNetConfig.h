//
//  TestNetConfig.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/20.
//  Copyright © 2016年 cn. All rights reserved.
//

/**
 *  TUNetworking Config 配置文件
 */

#import <Foundation/Foundation.h>
#import "TUNetworkConfig.h"

@interface TestNetConfig : NSObject <TUNetworkConfigProtocol>

+ (id<TUNetworkConfigProtocol>)config;

- (void)updateUserId:(NSString *)userId;

- (void)updatePublicParameters:(NSDictionary *)publicParameters;

@end
