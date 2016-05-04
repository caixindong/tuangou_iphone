//
//  LoginViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/4.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property(nonatomic,strong) MBProgressHUD* hud;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toRegisterVCBtnClick:(UIButton *)sender {
    RegisterViewController* rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)loginBtnClick:(UIButton *)sender {
    NSString* phoneNum = _phoneNumLabel.text;
    NSString* password = _passwordLabel.text;
    if ([phoneNum isEqualToString:@""]||[password isEqualToString:@""]) {
        [Utils showAlertViewWithTitle:@"" andMessage:@"账号或密码为空" inController:self withCancleActionHandler:nil withCompletion:nil];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"登录中";
    [PFUser logInWithUsernameInBackground:phoneNum password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (user!=nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString* username = user.username;
            [[NSUserDefaults standardUserDefaults]setValue:username forKey:username1];
            [[NSNotificationCenter defaultCenter]postNotificationName:isLogin1 object:nil];
            [Utils showAlertViewWithTitle:@"" andMessage:@"登陆成功" inController:self withCancleActionHandler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            } withCompletion:nil];

        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlertViewWithTitle:@"" andMessage:@"登录失败" inController:self withCancleActionHandler:nil withCompletion:nil];
            
        }
        
    }];
}

@end
