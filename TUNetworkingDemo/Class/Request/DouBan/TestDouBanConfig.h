//
//  TestDouBanConfig.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/16.
//  Copyright © 2017年 cn. All rights reserved.
//

/**
 *  DouBan Config 配置文件
 */

#import <Foundation/Foundation.h>
#import "TUNetworkConfig.h"

@interface TestDouBanConfig : NSObject <TUNetworkConfigProtocol>

@property (nonatomic, copy) NSString *token;

+ (instancetype)config;

- (void)updateUserId:(NSString *)userId;

@end
