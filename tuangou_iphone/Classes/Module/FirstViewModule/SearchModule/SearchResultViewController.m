//
//  SearchResultViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/1.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DetailViewController.h"
@interface SearchResultViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DPRequestDelegate>

@property(nonatomic,strong)NetworkRequest* networkRequest;
@property(nonatomic,strong)NSArray* tableData;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar1;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar1.text = _searchText;
    [self setupTableView];
    [self request];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)setupTableView{
    [_myTableView registerNib:[UINib nibWithNibName:CELLID bundle:nil] forCellReuseIdentifier:CELLID];
}

#pragma mark - 网络请求
-(void)request{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSString* name = [[NSUserDefaults standardUserDefaults] stringForKey:cityName1];
    [params setValue:name forKey:city1];
    [params setValue:_searchText forKey:keyword1];
    _networkRequest = [[NetworkRequest alloc]initWithDelegate:self];
    [_networkRequest requestWithParams:params];
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    NSDictionary* dict = (NSDictionary*)result;
    dealModel* model = [[dealModel alloc]init];
    _tableData = [model asignModelWithDict:dict];
    [_myTableView reloadData];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"dp api error is %@",error);
}

#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DealTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    dealModel* model = (dealModel*)_tableData[indexPath.row];
    [cell showUIWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DealTableViewCell heightOfCell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    dealModel* model = (dealModel*)_tableData[indexPath.row];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - searchBar delegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:NO];
    return YES;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



@end
