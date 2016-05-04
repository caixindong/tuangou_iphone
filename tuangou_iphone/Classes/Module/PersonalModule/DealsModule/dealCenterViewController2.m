//
//  dealCenterViewController2.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/23.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "dealCenterViewController2.h"
#import "PayDealTableViewCell.h"
#import "PayForViewController.h"
@interface dealCenterViewController2 ()<UITableViewDataSource,UITableViewDelegate,PayDealTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray* tableViewData;
@end

@implementation dealCenterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self getData];
    [self setupTableView];
    
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    _tableViewData = [NSMutableArray arrayWithArray: [LocalDealData getDeals]];
}
-(void)setupTableView{
    [_myTableView registerNib:[UINib nibWithNibName:CELLID5 bundle:nil] forCellReuseIdentifier:CELLID5];
}
#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableViewData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PayDealTableViewCell heightOfCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayDealTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID5];
    NSData* data = _tableViewData[indexPath.row];
    PayDealModel* model = (PayDealModel*)[FastCoder objectWithData:data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell showUIWithModel:model];
    return cell;
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSData* data = _tableViewData[indexPath.row];
    PayDealModel* model = (PayDealModel*)[FastCoder objectWithData:data];
    PayForViewController* pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PayForViewController"];
    pvc.dealID = model.paydealID;
    pvc.price = model.sumPrice;
    pvc.name = model.titlt;
    [self.navigationController pushViewController:pvc animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消订单？";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSData* data = _tableViewData[indexPath.row];
    [LocalDealData removeObjectFromDeals:data];
    [_tableViewData removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - PayDealTableViewCellDelegate
-(void)cancleDealBtnClick:(UIButton *)sender{
    
}
-(void)payBtnClick:(UIButton *)sender{
    
}
@end
