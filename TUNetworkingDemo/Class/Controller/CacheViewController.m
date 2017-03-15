//
//  CacheViewController.m
//  TUNetworkingDemo
//
//  Created by chengxianghe on 2017/3/15.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "CacheViewController.h"
#import "TUCacheManager.h"

@interface CacheViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

@end

@implementation CacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onCalculateButtonClick:(UIButton *)sender {
    [self refreshCacheSize];
}

- (IBAction)onCleanButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    __weak typeof(self) weak_self = self;
    
    [TUCacheManager clearAllCacheWithCompletion:^{
        NSLog(@"清理缓存完成！");
        sender.enabled = YES;
        [weak_self refreshCacheSize];
    }];
}

- (void)refreshCacheSize {
    __weak typeof(self) weak_self = self;
    [TUCacheManager getCacheSizeOfAllWithCompletion:^(CGFloat totalSize) {
        weak_self.cacheLabel.text = [NSString stringWithFormat:@"request缓存大小：%.2f K", totalSize/1024];
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
