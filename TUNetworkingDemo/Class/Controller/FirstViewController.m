//
//  FirstViewController.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 16/4/14.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "FirstViewController.h"
#import "TUNetworking.h"
#import "TestRequest.h"
#import "HomePageModel.h"
#import "TestDownloadRequest.h"
#import "TUModelManager.h"

@interface FirstViewController ()

@property (nonatomic, strong) NSMutableArray *modelList;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (nonatomic, strong) TestRequest *request;
@property (nonatomic, strong) TestDownloadRequest *downRequest;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self refreshCacheSize];
    
//    TUDebugLog = NO;
    [TUNetworkHelper setDebugLog:YES];

    self.modelList = [NSMutableArray array];

    [self sendGETRequest];
    
    TestDownloadRequest *downRequest = [[TestDownloadRequest alloc] init];
    _downRequest = downRequest;
    
}

- (void)refreshCacheSize {
    [TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
        [self.cleanBtn setTitle:[NSString stringWithFormat:@"request缓存大小：%.2f K", totalSize/1024] forState:UIControlStateNormal];
    }];
}

// 普通GET请求
- (void)sendGETRequest {
    TestRequest *request = [[TestRequest alloc] init];
    _request = request;

    __weak typeof(self) weak_self = self;
    [request sendRequestWithCache:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable cacheResult, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"Read Cache Error:%@!", error.description);
        } else {
            NSLog(@"Read Cache Succeed For Request:%@", NSStringFromClass([request class]));
        }
    } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        HomePageModel *model = [TUModelManager modelClass:[HomePageModel class] withDict:baseRequest.responseObject];
        NSDictionary *dict = [TUModelManager modelToDictWithModel:model];
        NSLog(@"requestSuccess:%@, %lu", model, [[dict allKeys] count]);
        [weak_self refreshCacheSize];
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"requestFailur:%@", error.description);
    }];

}

- (IBAction)onCleanBtnClick:(UIButton *)sender {
    sender.enabled = NO;
    
    __weak typeof(self) weak_self = self;

    [TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
        NSLog(@"开始清理缓存！总缓存大小：%.2f M", totalSize/1024/1024);
        [TUCacheManager clearAllCacheWithCompletion:^{
            NSLog(@"清理缓存完成！");
            sender.enabled = YES;
            [weak_self refreshCacheSize];
        }];
    }];
}
- (IBAction)resume:(id)sender {
    [_downRequest resume];
}

- (IBAction)susspend:(id)sender {
    [_downRequest suspend];

}

- (IBAction)send:(id)sender {

    __weak typeof(self) weak_self = self;

    [_downRequest downloadWithCache:^(__kindof TUBaseRequest * _Nonnull baseRequest, id _Nullable cacheResult, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"downRequest Read Cache Error:%@!", error.description);
        } else {
            NSLog(@"downRequest Read Cache Succeed For Request:%@", NSStringFromClass([_downRequest class]));
        }
    } progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"downloadProgressBlock:%.2f -- %@, %@",  [progress fractionCompleted],[progress localizedDescription], [progress localizedAdditionalDescription]);
    } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id _Nullable responseObject) {
        NSLog(@"downRequest Success:%@", responseObject);
        [weak_self refreshCacheSize];
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"downRequest Failur:%@", error.description);
    }];

}

- (IBAction)cancel:(id)sender {
    [_downRequest cancelRequest];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
        [self.cleanBtn setTitle:[NSString stringWithFormat:@"request缓存大小：%.2f K", totalSize/1024] forState:UIControlStateNormal];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
