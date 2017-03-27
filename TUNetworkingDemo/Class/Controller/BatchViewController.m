//
//  BatchViewController.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/23.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "BatchViewController.h"
#import "TUNetworking.h"
#import "TestDouBanChannelRequest.h"

@interface BatchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, strong) NSMutableArray *dataSource3;
@property (nonatomic, strong) NSMutableArray *dataSource4;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BatchViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TUNetworkHelper setDebugLog:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"模拟出错" style:UIBarButtonItemStylePlain target:self action:@selector(onRight:)];
    
    [self sendBatchRequest2];

}

- (void)onRight:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"模拟出错"]) {
        sender.title = @"模拟成功";
    } else {
        sender.title = @"模拟出错";
    }

    [self.tableView reloadData];
    
    [self sendBatchRequest2];
}

- (NSArray<__kindof TUBaseRequest *> *)testRequests {
    NSMutableArray<__kindof TUBaseRequest *> *array = [NSMutableArray array];
    /*
     151 户外
     152 休息
     155 舒缓
     32  咖啡
     257 运动
     */
    
    BOOL tempFailur = [self.navigationItem.rightBarButtonItem.title isEqualToString:@"模拟出错"];
    
    TestDouBanChannelRequest *request1 = [[TestDouBanChannelRequest alloc] init];
    request1.channel_id = @"151";
    
    TestDouBanChannelRequest *request2 = [[TestDouBanChannelRequest alloc] init];
    request2.channel_id = tempFailur ? @"null" : @"152";

    TestDouBanChannelRequest *request3 = [[TestDouBanChannelRequest alloc] init];
    request3.channel_id = @"155";
    
    TestDouBanChannelRequest *request4 = [[TestDouBanChannelRequest alloc] init];
    request4.channel_id = @"32";

    [array addObject:request1];
    [array addObject:request2];
    [array addObject:request3];
    [array addObject:request4];
    
    return array;
}

// 普通模式 不管中间失败多少请求，只有当所有请求都结束或者超时才会回调
- (void)sendBatchRequest1 {
    __weak typeof(self)weak_self = self;
    [TUBatchRequest sendRequests:[self testRequests] requestMode:TUBatchRequestModeNormal progress:^(NSInteger totals, NSInteger completions) {
        NSLog(@"progress: total:%ld -- completion:%ld", totals, completions);
    } completion:^(__kindof NSArray<__kindof TUBaseRequest *> * _Nullable requests, NSError * _Nullable error) {
        NSLog(@"请求组结束 error仅当严格模式下或者超时有值");
        if (!error) {
            NSLog(@"请求组成功");
            TUBaseRequest *request1 = requests[0];
            TUBaseRequest *request2 = requests[1];
            TUBaseRequest *request3 = requests[2];
            TUBaseRequest *request4 = requests[3];
            
            weak_self.dataSource1 = [self getDataFromRequest:request1];
            weak_self.dataSource2 = [self getDataFromRequest:request2];
            weak_self.dataSource3 = [self getDataFromRequest:request3];
            weak_self.dataSource4 = [self getDataFromRequest:request4];
            
            [weak_self.tableView reloadData];
        } else {
            NSLog(@"请求组失败");
        }
    }];
}

// 严格模式 只要有一个请求失败就会放弃所有请求并且回调
- (void)sendBatchRequest2 {
    __weak typeof(self)weak_self = self;
    [TUBatchRequest sendRequests:[self testRequests] requestMode:TUBatchRequestModeStrict progress:^(NSInteger totals, NSInteger completions) {
        NSLog(@"progress: total:%ld -- completion:%ld", totals, completions);
    } completion:^(__kindof NSArray<__kindof TUBaseRequest *> * _Nullable requests, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"请求组成功");
            TUBaseRequest *request1 = requests[0];
            TUBaseRequest *request2 = requests[1];
            TUBaseRequest *request3 = requests[2];
            TUBaseRequest *request4 = requests[3];

            weak_self.dataSource1 = [self getDataFromRequest:request1];
            weak_self.dataSource2 = [self getDataFromRequest:request2];
            weak_self.dataSource3 = [self getDataFromRequest:request3];
            weak_self.dataSource4 = [self getDataFromRequest:request4];

            [weak_self.tableView reloadData];
        } else {
            NSLog(@"请求组失败");
        }
    }];
}

- (void)sendBatchRequest3 {
    __weak typeof(self)weak_self = self;
    TUBatchRequest *batch = [[TUBatchRequest alloc] init];
    [batch sendRequests:[self testRequests] requestMode:TUBatchRequestModeNormal maxTime:0 progress:^(NSInteger totals, NSInteger completions) {
        NSLog(@"progress: total:%ld -- completion:%ld", totals, completions);
    } oneProgress:^(__kindof TUBaseRequest * _Nonnull request, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"oneProgress success: request:%@", [request class]);
        } else {
            NSLog(@"oneProgress failur: request:%@ error:%@", [request class], error.localizedDescription);
        }
    } completion:^(__kindof NSArray<__kindof TUBaseRequest *> * _Nullable requests, NSError * _Nullable error) {
        NSLog(@"请求组结束 error仅当严格模式下或者超时有值");
        if (!error) {
            NSLog(@"请求组成功");
            TUBaseRequest *request1 = requests[0];
            TUBaseRequest *request2 = requests[1];
            TUBaseRequest *request3 = requests[2];
            TUBaseRequest *request4 = requests[3];

            weak_self.dataSource1 = [self getDataFromRequest:request1];
            weak_self.dataSource2 = [self getDataFromRequest:request2];
            weak_self.dataSource3 = [self getDataFromRequest:request3];
            weak_self.dataSource4 = [self getDataFromRequest:request4];
            
            [weak_self.tableView reloadData];
        } else {
            NSLog(@"请求组失败");
        }
    }];
}

- (NSMutableArray *)getDataFromRequest:(TUBaseRequest *)request {
    if (request.cacheOption == TURequestCacheOptionNone || request.cacheOption == TURequestCacheOptionCachePriority) {
        return request.responseObject[@"song"];
    } else {
        if (request.cacheOption == TURequestCacheOptionCacheOnly) {
            return request.cacheResponseObject[@"song"];
        } else if (request.cacheOption == TURequestCacheOptionCacheSaveFlow) {
            if (request.cacheResponseObject) {
                return request.cacheResponseObject[@"song"];
            } else {
                return request.responseObject[@"song"];
            }
        } else {
            //TURequestCacheOptionRefreshPriority
            if (request.responseObject) {
                return request.responseObject[@"song"];
            } else {
                return request.cacheResponseObject[@"song"];
            }
        }
    }
}

#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource1.count;
    } else if (section == 1) {
        return self.dataSource2.count;
    } else if (section == 2) {
        return self.dataSource3.count;
    } else {
        return self.dataSource4.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"batchCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.dataSource1[indexPath.row][@"title"];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.dataSource2[indexPath.row][@"title"];
    } else if (indexPath.section == 2) {
        cell.textLabel.text = self.dataSource3[indexPath.row][@"title"];
    } else {
        cell.textLabel.text = self.dataSource4[indexPath.row][@"title"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"数据来源%ld", (long)section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
