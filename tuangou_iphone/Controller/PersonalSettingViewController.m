//
//  PersonalSettingViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/6.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "PersonalSettingViewController.h"

@interface PersonalSettingViewController ()
@property(nonatomic,strong)MBProgressHUD* hud;
@end

@implementation PersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的设置";
    
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginOutBtnClick:(UIButton *)sender {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"退出登录中";
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:username1];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utils showAlertViewWithTitle:@"" andMessage:@"退出失败，请重试" inController:self withCancleActionHandler:nil withCompletion:nil];
        }else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:logout1 object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
