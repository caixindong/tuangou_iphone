//
//  CityResultTableViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/30.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "CityResultTableViewController.h"
#import "Cities.h"
@interface CityResultTableViewController ()
@property(nonatomic,strong)NSArray* citiesArr;
@property(nonatomic,strong)NSMutableArray* searchResultArr;
@end

@implementation CityResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 接收传入的searchText并刷新数据
-(void)setSearchText:(NSString *)searchText{
    _searchText = [searchText lowercaseString];
    if (!_citiesArr) {
        _citiesArr = [Cities getCities];
    }
    _searchResultArr = [[NSMutableArray alloc]init];
    for (Cities *city in _citiesArr) {
        if ([city.name containsString:_searchText]||[city.pinYin containsString:_searchText]||[city.pinYinHead containsString:_searchText]) {
            [_searchResultArr addObject:city];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEACHCELLID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SEACHCELLID];
    }
    Cities* model = _searchResultArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

#pragma mark - tabelView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Cities* model = _searchResultArr[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setValue:model.name forKey:cityName1];
    [[NSNotificationCenter defaultCenter]postNotificationName:CITYCHANGE1 object:nil userInfo:@{cityName1:model.name}];
    [[NSNotificationCenter defaultCenter]postNotificationName:dismiss1 object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
