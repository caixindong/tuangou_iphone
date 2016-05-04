//
//  dealGoodsViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/12.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "dealGoodsViewController.h"
#import "LoginViewController.h"
#import "PayForViewController.h"
#import "PayDealModel.h"
@interface dealGoodsViewController ()<UITableViewDataSource>{
    float _price;
    NSString* _title;
}
@property(nonatomic,weak)UILabel* titleLabel;
@property(nonatomic,weak)UILabel* priceLabel;
@property(nonatomic,weak)UIButton* addBtn;
@property(nonatomic,weak)UIButton* subBtn;
@property(nonatomic,weak)UITextField* numLabel;
@property(nonatomic,weak)UILabel* sumLabel;
@end

@implementation dealGoodsViewController

- (void)viewDidLoad {
    self.title = @"提交订单";
    _price = [_model.current_price floatValue];
    _title = _model.title;
    [super viewDidLoad];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        _titleLabel = (UILabel*)[cell viewWithTag:1];
        _titleLabel.text = _title;
        _priceLabel = (UILabel*)[cell viewWithTag:2];
        _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",_price];
    }else if(indexPath.row==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        _subBtn = (UIButton*)[cell viewWithTag:1];
        [_subBtn addTarget:self action:@selector(subCount:) forControlEvents:UIControlEventTouchUpInside];
        [_subBtn setEnabled:NO];
        _numLabel = (UITextField*)[cell viewWithTag:2];
        _addBtn = (UIButton*)[cell viewWithTag:3];
        [_addBtn addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        _sumLabel = (UILabel*)[cell viewWithTag:1];
        
        _sumLabel.text = [NSString stringWithFormat:@"￥%.2f",_price];
    }
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    return cell;
    
}
#pragma mark - 减按钮点击事件
-(void)subCount:(UIButton*)sender{
    int i = [_numLabel.text intValue];
    i--;
    if (i<=1) {
        [sender setEnabled:NO];
    }else{
        [sender setEnabled:YES];
    }
    [_numLabel setText:[NSString stringWithFormat:@"%d",i]];
    [_sumLabel setText:[NSString stringWithFormat:@"￥%.2f",_price*i]];
}
#pragma mark - 加按钮点击事件
-(void)addCount:(UIButton*)sender{
    [_subBtn setEnabled:YES];
    int i = [_numLabel.text intValue];
    i++;
    [_numLabel setText:[NSString stringWithFormat:@"%d",i]];
    [_sumLabel setText:[NSString stringWithFormat:@"￥%.2f",_price*i]];
}
- (IBAction)payBtnClick:(UIButton *)sender{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:username1]) {
        NSString* dealID =  [self getCurrentTimeCore];
        int count = [_numLabel.text intValue];
        float payFor = count*_price;
        NSString* goodName = _titleLabel.text;
        
        
        PayDealModel* payDealModel = [[PayDealModel alloc]init];
        payDealModel.paydealID = dealID;
        payDealModel.titlt = goodName;
        payDealModel.count = count;
        payDealModel.sumPrice = payFor;
        payDealModel.paydealImgUrl = _model.image_url;
        
        NSData* data = [FastCoder dataWithRootObject:payDealModel];
        
        //NSDictionary* dict = @{dealID1:dealID,dealCource1:@(payFor),dealTitle1:goodName};
        
        [LocalDealData addObjectToDeals:data];
        
        
        
        PayForViewController* pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayForViewController"];
        pvc.name = goodName;
        pvc.price = payFor;
        pvc.dealID = dealID;
        [self.navigationController pushViewController:pvc animated:YES];
        
    }else{
        LoginViewController* lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}
-(NSString*)getCurrentTimeCore{
    NSDate* now = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlag = NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlag fromDate:now];
    NSString* dateCode = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld",[dateComponent year],[dateComponent month],[dateComponent day],[dateComponent hour],[dateComponent minute],[dateComponent second]];
    return dateCode;
}
@end
