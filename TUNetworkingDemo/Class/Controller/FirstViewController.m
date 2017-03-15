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
#import "TestViewController.h"

@interface FirstViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *testList;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [TUNetworkHelper setDebugLog:YES];
    

    self.testList = [NSMutableArray arrayWithObjects:
                     @"普通请求",
                     @"下载请求",
                     @"上传请求",
                     @"缓存相关",
                     @"Config",
                     nil];

}

#pragma mark - UITableViewDataSorce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.testList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.testList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 3) {
        [self performSegueWithIdentifier:@"showRequest" sender:indexPath];
    } else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"showCache" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"showDouBan" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showRequest"]) {
        TestViewController *test = (TestViewController *)[segue destinationViewController];
        test.type = [(NSIndexPath *)sender row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
