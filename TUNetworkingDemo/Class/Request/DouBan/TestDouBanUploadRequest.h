//
//  TestUploadRequest.h
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/15.
//  Copyright © 2017年 cn. All rights reserved.
//

/**
 豆瓣FM的上传头像的api
 https://api.douban.com/v2/lifestream/user/~me
 
 PUT /v2/lifestream/user/~me HTTP/1.1
 
 Content-Type: multipart/form-data; boundary=Boundary+2B4AC46B71AA4310
 
 Authorization: Bearer 334952619d19f9d699dbf724d74ded82
 
 
 Content-Disposition: form-data; name="image"; filename="image"
 Content-Type: image/jpeg
 
 */

#import "TUUploadRequest.h"

@interface TestDouBanUploadRequest : TUUploadRequest

@property (nonatomic, strong) UIImage *image;

@end
