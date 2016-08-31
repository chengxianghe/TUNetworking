//
//  TUURLSessionOperation.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/5/16.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUURLSessionOperation : NSOperation

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task;

@end
