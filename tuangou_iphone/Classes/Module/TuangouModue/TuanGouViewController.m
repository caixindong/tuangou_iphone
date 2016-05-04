//
//  TuanGouViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/28.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "TuanGouViewController.h"
#import "CategoriyModel.h"
#import "CityGroupModel.h"
#import "DealTableViewCell.h"
#import "DetailViewController.h"
@interface TuanGouViewController ()<XDDropDownMenuDataSource,XDDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,DPRequestDelegate,AMapLocationManagerDelegate>{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    
    int _selectRadius;
    int _selectSort;
    int _page;
    int _flag;
    int _isLocated;
}
@property(nonatomic,strong)UITableView* myTableView;
@property(nonatomic,strong)NSMutableArray* tableViewData;
@property(nonatomic,strong)NetworkRequest* networkRequest;
@property(nonatomic,assign)float longitude;
@property(nonatomic,assign)float latitude;
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)AMapLocationManager* manager;
@property(strong,nonatomic)UIButton* requestBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)XDDropDownMenu* menu;
@end

@implementation TuanGouViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLocateRequest];
    if (_myFlag==1) {
        _titleLabel.text = _selectCategory;
        [self setupBackBarButtonItem];
    }
    _isLocated = 0;
    [self setupMenu];
    [self setupTableView];
    [self setupMJRefresh];
    [self NormalRequest];
    [self addObserver];
    [self checkCurrentCityIsLocatedCity];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    if (_myFlag!=1) {
        self.tabBarController.tabBar.hidden = NO;
        NSLog(@"no hide tabbar");
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 定位
-(void)initLocateRequest{
    if ([CLLocationManager locationServicesEnabled]) {
        _manager = [[AMapLocationManager alloc]init];
        _manager.delegate = self;
        _manager.distanceFilter = 100;
    }else{
        [Utils showAlertViewWithTitle:@"" andMessage:@"你没开启定位功能" inController:self withCancleActionHandler:nil withCompletion:nil];
    }
}

#pragma mark - 添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityChange:) name:CITYCHANGE3 object:nil];
}

-(void)cityChange:(NSNotification*)noti{
    _selectCityName = [[NSUserDefaults standardUserDefaults]valueForKey:cityName1];
    _isLocated = 0;
    [self NormalRequest];
}

#pragma mark - 初始化数据
-(void)initData{
    _tableViewData = [[NSMutableArray alloc]init];
    _networkRequest = [[NetworkRequest alloc]initWithDelegate:self];
    if (_myFlag!=1) {
        _selectCategory = @"美食";
    }
    
    _selectCityName = [[NSUserDefaults standardUserDefaults] stringForKey:cityName1];
    if (_selectCityName == nil) {
        _selectCityName = @"广州";
    }
    
    _selectSort = 1;
    _selectRadius = 1000;
    _page = 1;
    _flag = 0;
    _isLocated = 0;
}

#pragma mark - setupBackBarButtonItem
-(void)setupBackBarButtonItem{
    UIButton* back = [[UIButton alloc]initWithFrame:CGRectMake(8,26, 30, 30)];
    [back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setup tableView
-(void)setupTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,109, self.view.frame.size.width, self.view.frame.size.height-109)];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:CELLID bundle:nil] forCellReuseIdentifier:CELLID];
    [self.view addSubview:_myTableView];
    [_myTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_myTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:109];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-150)/2,HEIGHT/2-150,150,150)];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = [UIImage imageNamed:@"icon_deals_empty"];
    [_myTableView addSubview:_imageView];
    _imageView.hidden = YES;
    
    _requestBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH-150)/2,HEIGHT/2-150,150,150)];
    [_requestBtn setImage:[UIImage imageNamed:@"bg_rotNetwork"] forState:UIControlStateNormal];
    [_requestBtn addTarget:self action:@selector(requestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myTableView addSubview:_requestBtn];
    _requestBtn.hidden = YES;
}

#pragma mark - 无法联网点击加载
-(void)requestBtnClick:(UIButton*)sender{
    [self NormalRequest];
}

#pragma mark - setup menu
-(void)setupMenu{
    _data1 = [[NSMutableArray alloc]init];
    NSArray* arr = [self getData];
    for (int i =0; i<arr.count; i++) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSString* name = [(CategoriyModel*)arr[i] name];
        NSArray* arr2 = [(CategoriyModel*)arr[i] subcategories];
        [dict setValue:name forKey:@"title"];
        [dict setValue:arr2 forKey:@"data"];
        [_data1 addObject:dict];
    }
    
    _data2 = [NSMutableArray arrayWithObjects:@"默认排序", @"价格最低", @"价格最高", @"人气最高", @"最新发布", @"即将结束", @"离我最近", nil];
    _data3 = [NSMutableArray arrayWithObjects:@500,@1000,@3000,@5000,@10000, nil];
    
    _menu = [[XDDropDownMenu alloc]initWithOrigin:CGPointMake(0,64) andHeight:45];
    _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _menu.seperatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    _menu.datasource = self;
    _menu.delegate = self;
    [self.view addSubview:_menu];
}

#pragma mark - 获取类别数据
-(NSArray*)getData{
    CategoriyModel* model = [[CategoriyModel alloc]init];
    return [model loadPlistData];
}

#pragma mark - setup 下拉刷新控件
-(void)setupMJRefresh{
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self NormalRequest];
        [_myTableView.header endRefreshing];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _myTableView.header = header;
    
    MJRefreshAutoNormalFooter* footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDataRequest];
        [_myTableView.footer endRefreshing];
    }];
    _myTableView.footer = footer;
}

#pragma mark - memu datasource
- (NSInteger)numberOfColumnsInMenu:(XDDropDownMenu *)menu{
    return 3;
}

- (NSString *)menu:(XDDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
    case 0:
        if (_myFlag!=1) {
            return @"团购";
        }else{
            return _selectCategory;
        }
        break;
    case 1: return _data2[_selectSort-1];
        break;
    case 2: return @"智能距离";
        break;
    default:
        return nil;
        break;
    }
}

-(NSInteger)menu:(XDDropDownMenu*)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        return _data2.count;
    }else if(column==2){
        return _data3.count;
    }
    return 0;
}

- (NSString *)menu:(XDDropDownMenu *)menu titleForRowAtIndexPath:(XDIndexPath *)indexPath{
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    }else if(indexPath.column==1){
        
        return _data2[indexPath.row];
    }else{
        if (indexPath.row==4) {
            return @"全城";
        }else{
            return [NSString stringWithFormat:@"%dm",[_data3[indexPath.row] intValue]];
        }
    }
}


-(CGFloat)proportionOfWidthInLeftColumn:(NSInteger)column{
    if (column==0) {
        return 0.3;
    }
    return 1;
}

-(BOOL)haveRightTableInColumn:(NSInteger)column{
    if (column==0) {
        return YES;
    }
    return NO;
}

-(NSInteger)currentSelectedRowInLeftTableOfColumn:(NSInteger)column{
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    if (column==2) {
        return _currentData3Index;
    }
    return 0;
}



#pragma mark - menu delegate
- (void)menu:(XDDropDownMenu *)menu didSelectRowAtIndexPath:(XDIndexPath *)indexPath{
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==1) {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            _selectCategory = [[menuDic objectForKey:@"data"]objectAtIndex:indexPath.row];
            if ([_selectCategory isEqualToString:@"全部"]) {
                _selectCategory = [menuDic objectForKey:@"title"];
            }
            [self NormalRequest];
        }else{
            _currentData1Index = indexPath.row;
        }
    }
    if (indexPath.column==1) {
        _currentData2Index = indexPath.row;
        _selectSort = (int)indexPath.row+1;
        [self NormalRequest];
    }
    if (indexPath.column==2) {
        _currentData3Index = indexPath.row;
        if (indexPath.row==4) {
            _isLocated = 0;
        }else{
            _isLocated = 1;
            _selectRadius = [_data3[indexPath.row] intValue];
        }
        [self NormalRequest];
    }
}

#pragma mark - tableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (_tableViewData.count==0) {
        _imageView.hidden = NO;
    }else{
        _requestBtn.hidden = YES;
        _imageView.hidden = YES;
    }
    if (_myFlag==1) {
        NSLog(@"title");
        _titleLabel.text= _selectCategory;
    }
    return _tableViewData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DealTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    dealModel* model = _tableViewData[indexPath.row];
    [cell showUIWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - tableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DealTableViewCell heightOfCell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dealModel* model = (dealModel*)_tableViewData[indexPath.row];
    DetailViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];

}

#pragma mark - 网络请求
-(void)request{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:_selectCityName forKey:city1];
    [params setValue:_selectCategory forKey:category1];
    if (_isLocated==1) {
        if (_latitude&&_longitude) {
            params[latitude1] = @(_latitude);
            params[longitude1] = @(_longitude);
            params[radius1] = @(_selectRadius);
        }
    }
    params[limit1] = @6;
    params[sort1] = @(_selectSort);
    params[page1] = @(_page);
    [_networkRequest requestWithParams:params];
}

-(void)NormalRequest{
    _flag = 0;
    _page = 1;
    [self request];
}

-(void)loadMoreDataRequest{
    _flag = 1;
    _page++;
    [self request];
}

#pragma mark - dp delegate
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary* dict = (NSDictionary*)result;
    dealModel* model = [[dealModel alloc]init];
    if (_flag==0) {
        _tableViewData = (NSMutableArray*)[model asignModelWithDict:dict];
        
    }else{
        NSArray* newArr = [model asignModelWithDict:dict];
        [_tableViewData addObjectsFromArray:newArr];
    }
    [_myTableView reloadData];
}

-(void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *estr = [NSString stringWithFormat:@"%@",error];
    if ([estr containsString:@"Error Domain=Required parameter city is missing"]) {
        [Utils showAlertViewWithTitle:@"" andMessage:@"先选择所在城市" inController:self withCancleActionHandler:nil withCompletion:nil];
        NSLog(@"city is missing");
    }else if([estr containsString:@"Error Domain=Parameter value is invalid: category"]){
        [Utils showAlertViewWithTitle:@"" andMessage:@"没有此类别的团购" inController:self withCancleActionHandler:nil withCompletion:nil];
        NSLog(@"没有团购");
    }else if([estr containsString:@"Error Domain=NSURLErrorDomain Code=-1009"]){
        [_tableViewData removeAllObjects];
        [_myTableView reloadData];
        _requestBtn.hidden = NO;
        _imageView.hidden = YES;
    }else{
        NSLog(@"dp api error is %@",error);
    }
}


#pragma mark - 附近按钮点击事件
- (IBAction)nearbyBtnClick:(UIButton *)sender {
    [_manager startUpdatingLocation];
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
    _isLocated = 1;
    _selectCityName = [[NSUserDefaults standardUserDefaults]valueForKey:locatedCity1];
    [[NSUserDefaults standardUserDefaults]setValue:_selectCityName forKey:cityName1];
    [self broadcastToFirstVC];
    [self NormalRequest];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"加载数据中";
    hud.userInteractionEnabled = NO;
    [_manager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [_manager stopUpdatingLocation];
    [Utils showAlertViewWithTitle:@"" andMessage:@"定位失败" inController:self withCancleActionHandler:nil withCompletion:nil];
    NSLog(@"location error is %@",error);
}

#pragma mark - 向首页发通知
-(void)broadcastToFirstVC{
    [[NSNotificationCenter defaultCenter]postNotificationName:CITYCHANGE4 object:nil];
}

#pragma mark - 检查当前城市是否为所在城市
-(void)checkCurrentCityIsLocatedCity{
    NSString* locatedCity = [[NSUserDefaults standardUserDefaults] valueForKey:locatedCity1];
    if (locatedCity) {
        if (![_selectCityName isEqualToString:locatedCity]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"当前定位的城市为 %@ ,是否切换到 %@ ",locatedCity,locatedCity] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* changeAction = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _selectCityName = locatedCity;
                [self request];
            }];
            UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"再逛逛" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:changeAction];
            [alert addAction:cancle];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}
@end
