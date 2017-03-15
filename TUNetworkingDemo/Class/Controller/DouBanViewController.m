//
//  DouBanViewController.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/15.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "DouBanViewController.h"
#import "TestDouBanChannelListRequest.h"
#import "TUNetworking.h"

@interface DouBanViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *dataButton;

@end

@implementation DouBanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)dataButtonPressed:(id)sender {
    
    TestDouBanChannelListRequest *request = [[TestDouBanChannelListRequest alloc] init];
    
    [request sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
        NSLog(@"reslut:%@", responseObject);
    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
    
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
