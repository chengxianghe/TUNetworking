//
//  TestUploadRequest.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/15.
//  Copyright © 2017年 cn. All rights reserved.
//

/**
 豆瓣FM的上传头像的api 需要登录
 https://api.douban.com/v2/lifestream/user/~me
 
 PUT /v2/lifestream/user/~me HTTP/1.1
 
 Content-Disposition: form-data; name="image"; filename="image"
 Content-Type: image/jpeg
 
 */

#import "TUUploadRequest.h"

@interface TestDouBanUploadRequest : TUUploadRequest

@property (nonatomic, strong) UIImage *image;

@end
