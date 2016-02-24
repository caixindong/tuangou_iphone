//
//  ChangePasswordViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/5.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property(nonatomic,strong)MBProgressHUD* hud;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
}

- (IBAction)sengBtnClick:(UIButton *)sender {
    [_emailLabel resignFirstResponder];
    NSString* email = _emailLabel.text;
    if ([email isEqualToString:@""]) {
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发送中";
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError * _Nullable error) {
        if (error!=nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlertViewWithTitle:@"" andMessage:@"邮件发送失败" inController:self withCancleActionHandler:nil withCompletion:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlertViewWithTitle:@"" andMessage:@"密码重置的信息已发完你的邮箱，请前往修改" inController:self withCancleActionHandler:nil withCompletion:nil];
        }
    }];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
