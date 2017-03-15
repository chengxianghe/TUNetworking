//
//  TUDouBanUserModel.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanUserModel.h"
#import <MJExtension/MJExtension.h>

@implementation TUDouBanUserModel

// 支持归档
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"token":@"access_token",
             @"user_id":@"douban_user_id",
             @"user_name":@"douban_user_name",
             @"refresh_token":@"refresh_token",
             @"expire":@"expires_in"};
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    if (self.expire.length <= 7) {
        //90天有效期
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

        self.expire = @(now + self.expire.longLongValue).stringValue;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"<Class:%@\n user_id:%@\n user_name:%@\n refresh_token:%@\n expire:%@\n token:%@",
            [TUDouBanUserModel class],_user_id, _user_name, _refresh_token, _expire, _token];
}

@end
