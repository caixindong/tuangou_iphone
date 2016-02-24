//
//  MyMapNaviViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/18.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "MyMapNaviViewController.h"
#import <MapKit/MapKit.h>
@interface MyMapNaviViewController ()<AMapNaviManagerDelegate,AMapNaviManagerDelegate,AMapNaviViewControllerDelegate,AMapLocationManagerDelegate>{
    MKCoordinateRegion _region;
}
@property(nonatomic,strong)AMapNaviManager* naviManager;
@property (nonatomic, strong) AMapNaviViewController *naviViewController;
@property(nonatomic,strong)MAMapView* mapView;
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property(nonatomic,strong)AMapLocationManager* locationMangager;
@end

@implementation MyMapNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路线导航";
    [self initLocationmanager];
    [self setupMapView];
    [self initMapView];
    [self initNaviManager];
    [self initNaviViewController];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initLocationmanager{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationMangager = [[AMapLocationManager alloc]init];
        _locationMangager.delegate = self;
        _locationMangager.distanceFilter = 100;
    }else{
        [Utils showAlertViewWithTitle:@"" andMessage:@"你没开启定位功能" inController:self withCancleActionHandler:nil withCompletion:nil];
    }
}
-(void)setupMapView{
    [_myMapView setShowsUserLocation:YES];
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(_latitude, _longitude);
    [annotation setTitle:_name];
    [_myMapView addAnnotation:annotation];
    _region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 500, 500);
    [_myMapView setRegion:[_myMapView regionThatFits:_region] animated:YES];
}
-(void)initMapView{
    [MAMapServices sharedServices].apiKey =@"d2e122617ba5dbdda1ffe52ef3353ffc";
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
}

- (IBAction)locateBtnClick:(UIButton *)sender {
    [_locationMangager startUpdatingLocation];
}

- (IBAction)refreshBtnClick:(UIButton *)sender {
    [_myMapView setRegion:[_myMapView regionThatFits:_region] animated:YES];
}


- (IBAction)naviDriveBtnClick:(UIButton *)sender {
    MBProgressHUD* hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"开启导航中...";
    [self driveRouteCalculate];
}
- (IBAction)naviWalkBtnClick:(UIButton *)sender {
    MBProgressHUD* hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"开启导航中...";
    [self walkRouteCalculate];
}
#pragma mark - 驾车路线
-(void)driveRouteCalculate{
    AMapNaviPoint* endPoint = [AMapNaviPoint locationWithLatitude:_latitude longitude:_longitude];
    NSArray* endPoints = @[endPoint];
    [_naviManager calculateDriveRouteWithEndPoints:endPoints wayPoints:nil drivingStrategy:0];
}
#pragma mark - 步行路线
-(void)walkRouteCalculate{
    AMapNaviPoint* endPoint = [AMapNaviPoint locationWithLatitude:_latitude longitude:_longitude];
    NSArray* endPoints = @[endPoint];
    [_naviManager calculateWalkRouteWithEndPoints:endPoints];
}
-(void)initNaviViewController{
    if (_naviViewController==nil) {
        _naviViewController = [[AMapNaviViewController alloc]initWithMapView:_mapView delegate:self];
    }
}
-(void)initNaviManager{
    if (_naviManager == nil) {
        _naviManager = [[AMapNaviManager alloc]init];
        [_naviManager setDelegate:self];
    }
}
#pragma mark - AMapNaviManagerDelegate
-(void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager{
    [_naviManager presentNaviViewController:_naviViewController animated:YES];
}
-(void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController{
    [_naviManager startGPSNavi];
}

-(void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController{
    [_naviManager stopNavi];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_naviManager dismissNaviViewControllerAnimated:YES];
}
#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [_locationMangager stopUpdatingLocation];
    NSLog(@"locate error is %@",error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    [_locationMangager stopUpdatingLocation];
    CLLocationCoordinate2D centerCoordinate2D = location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate2D, 1000, 1000);
    [_myMapView setRegion:[_myMapView regionThatFits:region] animated:YES];
    
}
@end
