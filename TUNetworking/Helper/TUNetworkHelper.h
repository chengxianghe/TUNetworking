//
//  TUNetworkHelper.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TUBaseRequest;

@interface TUNetworkHelper : NSObject

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

+ (void)setiTunesForbidBackupAttribute:(NSString *)path;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString*)urlEncode:(NSString*)str;

+ (NSString*)urlDecoded:(NSString *)str;

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;

+ (NSString *)appVersionString;

+ (NSMutableDictionary *)buildRequestHeader:(TUBaseRequest *)request;

+ (NSMutableDictionary *)buildRequestParameters:(TUBaseRequest *)request;

+ (NSString *)buildRequestUrl:(TUBaseRequest *)request;

+ (void)debugLogRequest:(TUBaseRequest *)request;

@end
