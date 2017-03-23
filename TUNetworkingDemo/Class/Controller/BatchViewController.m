//
//  BatchViewController.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/23.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "BatchViewController.h"
#import "TUNetworking.h"
#import "TestDouBanConfig.h"
#import "TestDouBanChannelRequest.h"
#import "TUDouBanLoginController.h"

@interface BatchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataSource2;
@property (nonatomic, strong) NSMutableArray *dataSource3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sendBatchRequest1];
}

- (void)check:(void(^)())completion {
    // 需要豆瓣先登录，此处使用豆瓣FM的上传头像接口作为测试
    TestDouBanConfig *config = (TestDouBanConfig *)[TestDouBanConfig config];
    
    if (!config.token.length) {
        //去登陆
        TUDouBanLoginController *vc = [TUDouBanLoginController loginControllerWithSuccess:^(TUDouBanUserModel *user) {
            if (completion) {
                completion();
            }
        } cancel:^(TUDouBanUserModel *user) {
            
        }];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        if (completion) {
            completion();
        }
    }
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
    
    
    TestDouBanChannelRequest *request1 = [[TestDouBanChannelRequest alloc] init];
    request1.channel_id = @"151";
    
    TestDouBanChannelRequest *request2 = [[TestDouBanChannelRequest alloc] init];
    request2.channel_id = @"152";

    TestDouBanChannelRequest *request3 = [[TestDouBanChannelRequest alloc] init];
    request3.channel_id = @"155";

    [array addObject:request1];
    [array addObject:request2];
    [array addObject:request3];

    return array;
}

- (void)sendBatchRequest1 {
    
    __weak typeof(self)weak_self = self;
    [self check:^{
        [TUBatchRequest sendRequests:[self testRequests] requestMode:TUBatchRequestModeNormal progress:^(NSInteger totals, NSInteger completions) {
            NSLog(@"progress: total:%ld -- completion:%ld", totals, completions);
        } completion:^(__kindof NSArray<__kindof TUBaseRequest *> * _Nullable requests, NSError * _Nullable error) {
            TUBaseRequest *request1 = requests[0];
            TUBaseRequest *request2 = requests[1];
            TUBaseRequest *request3 = requests[2];
            
            weak_self.dataSource1 = request1.responseObject[@"song"];
            weak_self.dataSource2 = request2.responseObject[@"song"];
            weak_self.dataSource3 = request3.responseObject[@"song"];
            [weak_self.tableView reloadData];
        }];
    }];
}

#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource1.count;
    } else if (section == 1) {
        return self.dataSource2.count;
    } else {
        return self.dataSource3.count;
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
    } else {
        cell.textLabel.text = self.dataSource3[indexPath.row][@"title"];
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
