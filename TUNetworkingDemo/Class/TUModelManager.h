//
//  TUModelManager.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUModelManager : NSObject

/// 字典 -> 模型
+ (id)modelClass:(Class)modelClass withDict:(NSDictionary *)dict;

/// 字典数组 -> 模型数组
+ (NSMutableArray *)modelClass:(Class)modelClass withDictArray:(NSArray *)dictArray;

/// 模型 -> 字典 
+ (NSDictionary *)modelToDictWithModel:(id)model;

@end
