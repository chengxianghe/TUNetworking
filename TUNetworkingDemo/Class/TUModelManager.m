//
//  TUModelManager.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUModelManager.h"
#import <MJExtension/MJExtension.h>

@implementation TUModelManager

+ (id)modelClass:(Class)modelClass withDict:(NSDictionary *)dict {
    id model = [modelClass mj_objectWithKeyValues:dict];
    return model;
}

+ (NSMutableArray *)modelClass:(Class)modelClass withDictArray:(NSArray *)dictArray {
    return [modelClass mj_objectArrayWithKeyValuesArray:dictArray];
}

+ (NSDictionary *)modelToDictWithModel:(id)model {
    NSDictionary *dict = [model mj_keyValues];
    return dict;
}

@end
