//
//  TUNetworkHelper.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUNetworkHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TUBaseRequest.h"
#import "TUNetworkConfig.h"

@implementation TUNetworkHelper

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    return urlParametersString;
}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}


+ (NSString*)urlEncode:(NSString*)str {
    //different library use slightly different escaped and unescaped set.
    //below is copied from AFNetworking but still escaped [] as AF leave them for Rails array parameter which we don't use.
    //https://github.com/AFNetworking/AFNetworking/pull/555
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
    return result;
}

+ (NSString*)urlDecoded:(NSString *)str {
    NSString *result = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(__bridge CFStringRef)str, CFSTR(""),kCFStringEncodingUTF8));
    
    return result;
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path {
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    // Borrowed from http://stackoverflow.com/questions/2439020/wheres-the-iphone-mime-type-database
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return CFBridgingRelease(MIMEType);
}

+ (void)setiTunesForbidBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        TULog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSMutableDictionary *)buildRequestHeader:(TUBaseRequest *)request {
    NSDictionary *param = [request requestHeaderFieldValueDictionary];
    NSMutableDictionary *mutiDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([request requestPublicParametersType] == TURequestPublicParametersTypeHeader) {
        [mutiDict setValuesForKeysWithDictionary:[[request requestConfig] requestPublicParameters]];
    }
    
    [mutiDict setValuesForKeysWithDictionary:param];
    return mutiDict;
}

+ (NSMutableDictionary *)buildRequestParameters:(TUBaseRequest *)request {
    NSDictionary *param = [request requestParameters];
    NSMutableDictionary *mutiDict = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if ([request requestPublicParametersType] == TURequestPublicParametersTypeBody) {
        [mutiDict setValuesForKeysWithDictionary:[[request requestConfig] requestPublicParameters]];
    }
    
    [mutiDict setValuesForKeysWithDictionary:param];
    return mutiDict;
}

+ (NSString *)buildRequestUrl:(TUBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        if ([request requestPublicParametersType] == TURequestPublicParametersTypeUrl) {
            detailUrl = [TUNetworkHelper urlStringWithOriginUrlString:detailUrl appendParameters:[[request requestConfig] requestPublicParameters]];
        }
        return detailUrl;
    }
    
    NSMutableString *baseUrl = [NSMutableString string];
    
    if ([request appProtocol].length > 0) {
        [baseUrl appendString:[request appProtocol]];
    }
    if ([request appHost].length > 0) {
        [baseUrl appendString:[request appHost]];
    }
    if ([request requestUrl].length > 0) {
        [baseUrl appendString:[request requestUrl]];
    }
    if ([request requestPublicParametersType] == TURequestPublicParametersTypeUrl) {
        baseUrl = (NSMutableString *)[TUNetworkHelper urlStringWithOriginUrlString:baseUrl appendParameters:[[request requestConfig] requestPublicParameters]];
    }
    
    return baseUrl;
}

+ (void)debugLogRequest:(TUBaseRequest *)request {
    NSURLRequest *urlRequest = [[request requestTask] currentRequest];
    TULog(@"CustomRequest Class:%@ Request: %@ \n allHTTPHeaderFields \n%@\n HTTPBody \n%@", [request class], urlRequest, [urlRequest allHTTPHeaderFields], [[NSString alloc] initWithData:[urlRequest HTTPBody] encoding:NSUTF8StringEncoding]);
}

@end
