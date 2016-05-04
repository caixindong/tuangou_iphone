//
//  PayForViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/16.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "PayForViewController.h"

@interface PayForViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dealIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation PayForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    _dealIDLabel.text = _dealID;
    _nameLabel.text = _name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_price];
}


- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
