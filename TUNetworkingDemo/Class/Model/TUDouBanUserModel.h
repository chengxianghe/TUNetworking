//
//  TUDouBanUserModel.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUDouBanUserModel : NSObject

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *refresh_token;

@end

/*
 {
 "access_token" = 21a0867e86f16fb464e1937b94d44ftt;
 "douban_user_id" = 145926981;
 "douban_user_name" = "XX";
 "expires_in" = 7775999;
 "refresh_token" = 77bc1538a652d3b867343fa9fff87b28;
 }
 */
