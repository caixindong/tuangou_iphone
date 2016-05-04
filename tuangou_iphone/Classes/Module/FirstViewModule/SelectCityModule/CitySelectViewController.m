//
//  CitySelectViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/29.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "CitySelectViewController.h"
#import "CityGroupModel.h"
#import "CityResultTableViewController.h"

@interface CitySelectViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar1;
@property(nonatomic,strong)NSArray* tabelData;
@property(nonatomic,strong)CityResultTableViewController* cityResultVC;
@end

@implementation CitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self addObserver];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissMyself:) name:dismiss1 object:nil];
}

-(void)dismissMyself:(NSNotification*)noti{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 创建搜索结果控制器
-(CityResultTableViewController *)cityResultVC{
    if (!_cityResultVC) {
        _cityResultVC = [[CityResultTableViewController alloc]init];
        [self.view addSubview:_cityResultVC.view];
        [_cityResultVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [_cityResultVC.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_searchBar1];
    }
    return _cityResultVC;
}

#pragma mark - 获取数据
-(void)getData{
    CityGroupModel* md = [[CityGroupModel alloc]init];
    _tabelData = [md getModelArray];
}

#pragma mark - tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tabelData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[(CityGroupModel*)_tabelData[section] cities] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [(CityGroupModel*)_tabelData[section] title];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID2];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID2];
    }
    CityGroupModel* md = _tabelData[indexPath.section];
    cell.textLabel.text = [md.cities objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityGroupModel* model = (CityGroupModel*)_tabelData[indexPath.section];
    NSString* name = [model.cities objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setValue:name forKey:cityName1];
    [[NSNotificationCenter defaultCenter]postNotificationName:CITYCHANGE2 object:nil userInfo:@{cityName1:name}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - searchBar delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _coverView.hidden = NO;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    _coverView.hidden = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length) {
        self.cityResultVC.view.hidden = NO;
        self.cityResultVC.searchText = searchText;
    }else{
        self.cityResultVC.view.hidden = YES;
    }
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
