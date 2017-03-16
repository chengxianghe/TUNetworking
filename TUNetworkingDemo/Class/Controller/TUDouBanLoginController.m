//
//  TUDouBanLoginControllerViewController.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/24.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDouBanLoginController.h"
#import "TestDouBanLoginRequest.h"
#import <MJExtension.h>
#import "TUNetworking.h"
#import "TUDouBanUserModel.h"
#import "TestDouBanConfig.h"

@interface TUDouBanLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) TestDouBanLoginRequest *loginRequest;
@property (nonatomic, copy) TUDouBanLoginBlock success;
@property (nonatomic, copy) TUDouBanLoginBlock cancel;

@end

@implementation TUDouBanLoginController

+ (instancetype)loginControllerWithSuccess:(TUDouBanLoginBlock)success cancel:(TUDouBanLoginBlock)cancel {
    TUDouBanLoginController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TUDouBanLoginController"];
    vc.success = success;
    vc.cancel = cancel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginRequest = [[TestDouBanLoginRequest alloc] init];
}

- (IBAction)onLoginBtnClick:(UIButton *)sender {
    NSString *eamil = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (!eamil.length || !password.length) {
        NSLog(@"请输入邮箱和密码");
        return;
    }
    
    self.loginRequest.email = eamil;
    self.loginRequest.password = password;
    
    __weak typeof(self) weak_self = self;
    [self.loginRequest sendRequestWithSuccess:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
  
        NSLog(@"登录成功！：%@", responseObject);
        TUDouBanUserModel *user = [TUDouBanUserModel mj_objectWithKeyValues:responseObject];
        
        //更新用户id
        TestDouBanConfig *config = [TestDouBanConfig config];
        [config updateUserId:user.user_id];
        config.token = user.token;
        
        [weak_self dismissViewControllerAnimated:YES completion:^{
            if (weak_self.success) {
                weak_self.success(user);
            }
        }];

    } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
        NSLog(@"登录失败：%@ response:%@", error, baseRequest.responseObject);
    }];
}

- (IBAction)onCancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancel) {
            self.cancel(nil);
        }
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
