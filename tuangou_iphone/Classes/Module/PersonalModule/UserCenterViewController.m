//
//  UserCenterViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/4.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "UserCenterViewController.h"
#import "LoginViewController.h"
#import "PersonalSettingViewController.h"
#import "CollectionViewController.h"
#import "dealCenterViewController2.h"
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    //为0代表未登录，为1代表已登录
    int _isLogined;
}
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property(nonatomic,strong)NSArray* tableData;
@property(nonatomic,strong)LoginViewController* lvc;
@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self initData];
    [self checkIsLogin];
    [self addObserver];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)initData{
    _tableData = @[@"我的收藏",@"我的订单",@"我的评价",@"我的设置"];
    _isLogined = 0;
}

#pragma mark - 检查是否登陆
-(void)checkIsLogin{
    NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:username1];
    if (username) {
        [_coverBtn setEnabled:NO];
        _usernameLabel.text = username;
        _isLogined = 1;
    }
}

#pragma mark - 添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveLogin:) name:isLogin1 object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveLogout:) name:logout1 object:nil];
}

-(void)haveLogin:(NSNotification*)noti{
    NSString* username = [[NSUserDefaults standardUserDefaults] stringForKey:username1];
    [_coverBtn setEnabled:NO];
    _usernameLabel.text = username;
    _isLogined = 1;
}

-(void)haveLogout:(NSNotification*)noti{
    [_coverBtn setEnabled:YES];
    _usernameLabel.text = @"未登录点击这里";
    _isLogined = 0;
}

#pragma mark - tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _tableData[indexPath.row];
    return cell;
}

#pragma mark - tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (_isLogined==0) {
            [self.navigationController pushViewController:self.lvc animated:YES];
        }else{
            if(indexPath.row==0) {
                CollectionViewController* cvc  = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionViewController"];
                [self.navigationController pushViewController:cvc animated:YES];
            }else if (indexPath.row==1) {
                dealCenterViewController2* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dealCenterViewController2"];
                [self.navigationController pushViewController:dvc animated:YES];
            }else if(indexPath.row==3){
                PersonalSettingViewController* psc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonalSettingViewController"];
                [self.navigationController pushViewController:psc animated:YES];
                
            }
        }
    
}

- (IBAction)toLoginVCClick:(UIButton *)sender {
    [self.navigationController pushViewController:self.lvc animated:NO];
}

#pragma mark LoginViewController懒加载
-(LoginViewController *)lvc{
    if (!_lvc) {
        _lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    return _lvc;
}

@end
