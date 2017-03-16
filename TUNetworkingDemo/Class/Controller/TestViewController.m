//
//  TestViewController.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/15.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "TestViewController.h"
#import "TestRequest.h"
#import "TUNetworking.h"
#import "TUModelManager.h"
#import "HomePageModel.h"
#import "TestDownloadRequest.h"
#import "TestDouBanConfig.h"
#import "TUDouBanLoginController.h"
#import "TestDouBanUploadRequest.h"
#import <UIImageView+AFNetworking.h>

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) TestDownloadRequest *downRequest;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type == 0) {
        // 普通请求
        self.textView.text = @"请求结果在此显示";
    } else if (self.type == 1) {
        // 下载请求
        self.textView.text = @"请查看控制台";
    } else {
        // 上传请求
        self.textView.text = @"上传使用的是豆瓣的上传用户头像的接口，需要登录豆瓣，上传图片会在右上角显示";
    }
}

- (IBAction)sendButtonPressed:(id)sender {
    if (self.type == 0) {
        // 普通请求
        [self sendGETRequest];
    } else if (self.type == 1) {
        // 下载请求
        [self sendDownloadRequest];
    } else {
        // 上传请求
        [self sendUploadRequest];
    }
}

- (IBAction)clearButtonPressed:(id)sender {
    self.textView.text = @"";
    
    [TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
        NSLog(@"开始清除缓存:%@", [NSString stringWithFormat:@"request缓存大小：%.2f K", totalSize/1024]);
        [TUCacheManager clearAllCacheWithCompletion:^{
            NSLog(@"清理缓存完成！");
        }];
    }];
}

// 普通GET请求
- (void)sendGETRequest {
    TestRequest *request = [[TestRequest alloc] init];
    
    __weak typeof(self) weak_self = self;
    [request sendRequestWithCache:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable cacheResult, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Read Cache Error:%@!", error.description);
        } else {
            NSLog(@"Read Cache Succeed For Request:%@", NSStringFromClass([request class]));
        }
    } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        weak_self.textView.text = [NSString stringWithFormat:@"%@", responseObject];
        HomePageModel *model = [TUModelManager modelClass:[HomePageModel class] withDict:baseRequest.responseObject];
        NSDictionary *dict = [TUModelManager modelToDictWithModel:model];
        NSLog(@"requestSuccess:%@, %lu", model, [[dict allKeys] count]);
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"requestFailur:%@", error.description);
    }];
}

- (void)sendDownloadRequest {
    TestDownloadRequest *download = [[TestDownloadRequest alloc] init];
    
    [download downloadWithCache:^(__kindof TUBaseRequest * _Nonnull baseRequest, id _Nullable cacheResult, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"downRequest Read Cache Error:%@!", error.description);
        } else {
            NSLog(@"downRequest Read Cache Succeed For Request:%@, path:%@", NSStringFromClass([download class]), [baseRequest cachePath]);
        }
    } progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"downloadProgressBlock:%.2f -- %@, %@",  [progress fractionCompleted],[progress localizedDescription], [progress localizedAdditionalDescription]);
    } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id _Nullable responseObject) {
        NSLog(@"downRequest Success:%@", responseObject);
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"downRequest Failur:%@", error.description);
    }];
}

- (void)sendUploadRequest {
    // 需要豆瓣先登录，此处使用豆瓣FM的上传头像接口作为测试
    TestDouBanConfig *config = (TestDouBanConfig *)[TestDouBanConfig config];

    if (!config.token.length) {
        //去登陆
        TUDouBanLoginController *vc = [TUDouBanLoginController loginControllerWithSuccess:^(TUDouBanUserModel *user) {
            
        } cancel:^(TUDouBanUserModel *user) {
            
        }];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        TestDouBanUploadRequest *upload = [[TestDouBanUploadRequest alloc] init];
        UIImage *image = [UIImage imageNamed:@"test_big.jpg"];
        
        __weak typeof(self)weak_self = self;
        [upload uploadWithConstructingBody:^(__kindof id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data = UIImageJPEGRepresentation(image, 0.9);
            NSString *name = @"image";
            NSString *formKey = @"image";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        } progress:^(__kindof NSProgress * _Nonnull progress) {
            NSLog(@"上传进度:%.2f -- %@, %@",  [progress fractionCompleted],[progress localizedDescription], [progress localizedAdditionalDescription]);
        } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            NSLog(@"upload Success:%@", responseObject);
            
            [weak_self.iconImageView setImageWithURL:[NSURL URLWithString:responseObject[@"large_avatar"]]];
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            NSLog(@"upload Failur:%@", error.description);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
