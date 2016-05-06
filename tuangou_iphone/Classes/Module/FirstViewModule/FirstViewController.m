//
//  FirstViewController2.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/12/2.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "FirstViewController.h"
#import "TuanGouViewController.h"
#import "CitySelectViewController.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "FirstVCHeaderView.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,DPRequestDelegate,UISearchBarDelegate,FirstVCHeaderViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)FirstVCHeaderView* myHeaderView;
@property(nonatomic,strong)NSMutableArray* tableViewDataSource;
@property(nonatomic,strong)NSString* selectCityName;
@property(nonatomic,strong)NetworkRequest* networkRequest;
@property(nonatomic,strong)NSArray* itemTitles;
@property(strong,nonatomic)UIButton* requestBtn;
@property(nonatomic,strong)AMapLocationManager* locationManager;
@property(nonatomic,strong)UIButton* getMoreBtn;
@property(nonatomic,strong)MJRefreshNormalHeader* header;
@end

@interface FirstViewController (handle)
/**
 * 定位
 **/
-(void)locateRequest;

/**
 * 从NSUserDefaults获取城市数据
 **/
-(void)getCityInUserDefault;

/**
 * 向TuanGouViewController发通知
 **/
-(void)broadcasttoTuanGouVC;

/**
 * 检查当前城市是否为所在城市
 **/
-(void)checkCurrentCityIsLocatedCity;

/**
 * 网络请求
 **/
-(void)request;
@end


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    
    [self locateRequest];
    [self getCityInUserDefault];
    
    
    
    self.myTableView.tableHeaderView = self.myHeaderView;
    _myTableView.tableFooterView = self.getMoreBtn;
    [_myTableView addSubview:self.requestBtn];
    _requestBtn.hidden = YES;
    _myTableView.header = _header;
    
    [self request];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityChange:) name:CITYCHANGE1 object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityChange2:) name:CITYCHANGE2 object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityChange4:) name:CITYCHANGE4 object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.mySearchBar resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - dpapi delegate
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary* dict = result;
    dealModel* md = [[dealModel alloc]init];
    _tableViewDataSource =  [NSMutableArray arrayWithArray:[md asignModelWithDict:dict]];
    [_myTableView reloadData];
}

-(void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *estr = [NSString stringWithFormat:@"%@",error];
    if ([estr containsString:@"Error Domain=Required parameter city is missing"]) {
        NSLog(@"city is missing");
    }else if([estr containsString:@"Error Domain=NSURLErrorDomain Code=-1009"]){
        [_tableViewDataSource removeAllObjects];
        [_myTableView reloadData];
        _requestBtn.hidden = NO;
    }else{
        NSLog(@"%@",error);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _cityLabel.text = _selectCityName;
    if (_tableViewDataSource.count>0) {
        _requestBtn.hidden = YES;
    }
    [self checkCurrentCityIsLocatedCity];
    return _tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DealTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    dealModel* md = _tableViewDataSource[indexPath.row];
    [cell showUIWithModel:md];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DealTableViewCell heightOfCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DealTableViewCell heightOfCell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dealModel* model = _tableViewDataSource[indexPath.row];
    DetailViewController* cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    cvc.model = model;
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchViewController* svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:svc animated:NO];
    return YES;
}

#pragma mark - FirstVCHeaderViewDelegate
-(void)itemClick:(UIButton *)sender{
    int index = (int)sender.tag-1;
    NSString* selectCategory = self.itemTitles[index];
    TuanGouViewController* tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TuanGouViewController"];
    tvc.selectCityName = _selectCityName;
    tvc.selectCategory = selectCategory;
    tvc.myFlag = 1;
    [self.navigationController pushViewController:tvc animated:YES];
}


#pragma mark - event response
/**
 * 城市选择按钮
 **/
- (IBAction)cityBtnClick:(UIButton *)sender {
    CitySelectViewController* csv = [self.storyboard instantiateViewControllerWithIdentifier:@"CitySelectViewController"];
    [self.navigationController pushViewController:csv animated:YES];
}
/**
 * 定位按钮
 **/
- (IBAction)locateBtnClick:(UIButton *)sender {
    [self locateRequest];
}

-(void)requestBtnClick:(UIButton*)sender{
    [self request];
}

-(void)getMore:(UIButton*)sender{
    [self.tabBarController setSelectedIndex:1];
}

-(void)cityChange:(NSNotification*)noti{
    _selectCityName = (NSString*)[noti.userInfo valueForKey:cityName1];
    [self broadcasttoTuanGouVC];
    [self request];
}

-(void)cityChange2:(NSNotification*)noti{
    _selectCityName = (NSString*)[noti.userInfo valueForKey:cityName1];
    [self broadcasttoTuanGouVC];
    [self request];
}

-(void)cityChange4:(NSNotification*)noti{
    _selectCityName = [[NSUserDefaults standardUserDefaults]valueForKey:cityName1];
    [self request];
}

#pragma mark - getter
-(UITableView *)myTableView{
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:CELLID bundle:nil] forCellReuseIdentifier:CELLID];
    return _myTableView;
}

-(FirstVCHeaderView *)myHeaderView{
    if (!_myHeaderView) {
        _myHeaderView = [[FirstVCHeaderView alloc]init];
        _myHeaderView.delegate = self;
        float height = 0;
        NSString* device = [Utils getDeviceName];
        if ([device isEqualToString:@"4"]) {
            height = 380;
        }else if([device isEqualToString:@"5"]){
            height = 283;
        }else if ([device isEqualToString:@"6"]){
            height = 200;
        }else if ([device isEqualToString:@"6+"]){
            height = 120;
        }
        [_myHeaderView setFrame:CGRectMake(0, 0, WIDTH,height)];
    }
    return _myHeaderView;
}

-(UIButton *)requestBtn{
    if (!_requestBtn) {
        _requestBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH-150)/2, 10,150,150)];
        [_requestBtn setImage:[UIImage imageNamed:@"bg_rotNetwork"] forState:UIControlStateNormal];
        [_requestBtn addTarget:self action:@selector(requestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _requestBtn;
}

-(UIButton *)getMoreBtn{
    if (!_getMoreBtn) {
        _getMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        _getMoreBtn.backgroundColor = [UIColor whiteColor];
        _getMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_getMoreBtn setTitle:@"查看全部团购" forState:UIControlStateNormal ];
        [_getMoreBtn setTitleColor:[UIColor colorWithRed:0.16 green:0.76 blue:0.55 alpha:1.0] forState:UIControlStateNormal];
        _getMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_getMoreBtn addTarget:self action:@selector(getMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getMoreBtn;
}

-(MJRefreshNormalHeader *)header{
    if (!_header) {
        MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self request];
            [_myTableView.header endRefreshing];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
    }
    return _header;
}

-(NetworkRequest *)networkRequest{
    if (!_networkRequest) {
        _networkRequest = [[NetworkRequest alloc]initWithDelegate:self];
    }
    return _networkRequest;
}

-(NSArray *)itemTitles{
    if (!_itemTitles) {
        _itemTitles = @[@"美食",@"电影",@"酒店",@"休闲娱乐",@"丽人",@"生活服务",@"购物",@"旅游"];
    }
    return _itemTitles;
}

@end

@implementation FirstViewController (handle)

-(void)locateRequest{
    self.locationManager = [[AMapLocationManager alloc]init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locate error is %@",error);
        }
        if (regeocode) {
            NSString* city = regeocode.city;
            NSString* str = [city substringToIndex:2];
            _selectCityName = str;
            [[NSUserDefaults standardUserDefaults]setValue:str forKey:locatedCity1];
            [[NSUserDefaults standardUserDefaults]setValue:_selectCityName forKey:cityName1];
            [self broadcasttoTuanGouVC];
            [self request];
            NSLog(@"首页-当前城市为%@",_selectCityName);
        }
    }];
}

-(void)getCityInUserDefault{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if ([ud stringForKey:cityName1]) {
        _selectCityName = [ud stringForKey:cityName1];
    }
    if (_selectCityName==nil) {
        _selectCityName = @"广州";
    }
}

-(void)broadcasttoTuanGouVC{
    if (_selectCityName) {
        [[NSUserDefaults standardUserDefaults]setValue:_selectCityName forKey:cityName1];
        [[NSNotificationCenter defaultCenter]postNotificationName:CITYCHANGE3 object:nil];
    }
}

-(void)checkCurrentCityIsLocatedCity{
    NSString* locatedCity = [[NSUserDefaults standardUserDefaults] valueForKey:locatedCity1];
    if (locatedCity) {
        if (![_selectCityName isEqualToString:locatedCity]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"当前定位的城市为 %@ ,是否切换为 %@ ",locatedCity,locatedCity] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* changeAction = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _selectCityName = locatedCity;
                [self request];
                [self broadcasttoTuanGouVC];
            }];
            UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"再逛逛" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:changeAction];
            [alert addAction:cancle];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
 
}

-(void)request{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"加载数据中";
    hud.userInteractionEnabled = NO;
    NSLog(@"city is %@",_selectCityName);
    if (_selectCityName) {
        NSDictionary* params = @{city1:_selectCityName,category1:@"美食",limit1:@20,sort1:@1};
        NSMutableDictionary* mulParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [self.networkRequest requestWithParams:mulParams];
    }
    
}
@end
