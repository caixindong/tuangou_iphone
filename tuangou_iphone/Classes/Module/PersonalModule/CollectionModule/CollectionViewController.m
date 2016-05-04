//
//  CollectionViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/11.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectedTableViewCell.h"
#import "DetailViewController.h"
@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray* tabelData;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self setupRightBarItem];
    [self getData];
    [self setupTableView];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    _tabelData =[NSMutableArray arrayWithArray:[CollectionData getCollection]];
}
-(void)setupTableView{
    [_myTableView registerNib:[UINib nibWithNibName:CELLID3 bundle:nil] forCellReuseIdentifier:CELLID3];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
}
-(void)setupRightBarItem{
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick:)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)rightBarItemClick:(UIBarButtonItem*)sender{
    [_myTableView setEditing:!_myTableView.editing animated:YES];
    if (_myTableView.editing) {
        sender.title = @"完成";
    }else{
        sender.title = @"编辑";
    }
}
#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tabelData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CollectedTableViewCell heightOfCell];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID3];
    [cell showUIWithDict:(NSDictionary*)_tabelData[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dict = _tabelData[indexPath.row];
    NSData* data = dict[data1];
    dealModel* model = (dealModel*)[FastCoder objectWithData:data];
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除？";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dict = _tabelData[indexPath.row];
    [CollectionData removeObjectFromCollection:dict];
    [_tabelData removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
