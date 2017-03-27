//
//  TUDouBanMusicRequest.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TestDouBanChannelRequest.h"

//频道0歌曲数据网址
//http://douban.fm/j/mine/playlist?type=n&channel=0&from=mainsite

// 更新 https://api.douban.com/v2/fm/playlist?channel=10&formats=aac&kbps=128&pt=0.0&type=n

@implementation TestDouBanChannelRequest

- (TURequestCacheOption)cacheOption {
    return TURequestCacheOptionCacheSaveFlow;
}

- (TURequestMethod)requestMethod {
    return TURequestMethodGet;
}

- (NSString *)requestUrl {
    if ([self.channel_id isEqual: @"null"]) {
        return @"/v2/fmmmmm";
    }
    return @"/v2/fm/playlist";
}

- (NSDictionary *)requestParameters {
    if (_channel_id == nil) {
        _channel_id = @"0";
    }
    
    return @{@"type" : @"n",
             @"channel" : _channel_id,
             @"from" : @"mainsite",
             @"pt":@"0.0",
             @"kbps":@"128",
             @"formats":@"aac",
             };
}

- (void)requestHandleResult {
    NSLog(@"%s", __func__);
}

@end
