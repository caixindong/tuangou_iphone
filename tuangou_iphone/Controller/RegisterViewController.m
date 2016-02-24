//
//  RegisterViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/4.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordLabel;
@property(nonatomic,strong) MBProgressHUD* hud;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)registerBtnClick:(UIButton *)sender {
    NSString* email = _emailLabel.text;
    NSString* phoneNum = _phoneNumLabel.text;
    NSString* password = _passwordLabel.text;
    NSString* againPassword = _againPasswordLabel.text;
    if ([email isEqualToString:@""]||[phoneNum isEqualToString:@""]||[password isEqualToString:@""]||[againPassword isEqualToString:@""]) {
        [Utils showAlertViewWithTitle:@"" andMessage:@"所有字段非空" inController:self withCancleActionHandler:nil withCompletion:nil];
        return;
    }
    if (![password isEqualToString:againPassword]) {
        [Utils showAlertViewWithTitle:@"" andMessage:@"两次输入的密码不同" inController:self withCancleActionHandler:nil withCompletion:nil];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"注册中";
    PFUser* user = [[PFUser alloc]init];
    user.username = phoneNum;
    user.password = password;
    user.email = email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlertViewWithTitle:@"" andMessage:@"注册失败,请重试" inController:self withCancleActionHandler:nil withCompletion:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlertViewWithTitle:@"" andMessage:@"注册成功" inController:self withCancleActionHandler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            } withCompletion:nil];
        }
    }];
    
    
}


@end
