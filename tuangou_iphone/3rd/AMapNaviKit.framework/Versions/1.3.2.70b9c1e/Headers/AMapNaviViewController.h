//
//  AMapNaviController.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-8-17.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit.h"
#import "AMapNaviCommonObj.h"

@protocol AMapNaviViewControllerDelegate;

/*!
 @brief 导航视图控制器,需调用AMapNaviManager的presentNaviViewController:animated:方法进行展示
 */
@interface AMapNaviViewController : UIViewController

#pragma mark - Initialization

/*
 由于导航SDK会复用用户的MapView,所以在以下两种操作前需要保存地图当前所有状态,导航SDK会重置mapView的所有状态,操作包括:
    1.在初始化AMapNaviViewController前
    2.在通过AMapNaviManager去展示AMapNaviViewController前
 将被重置的地图状态包括:
    1.重置MapView的delegate
    2.清除所有的Annotation和Overlay
    3.重置MapView的RotationDegree和CameraDegree
    4.重置MapView的比例尺,指南针,楼块,MapType和交通图层的显示状态
    5.重置MapView的visibleMapRect
    6.将MapView从其原来的视图层级中移除,并加入到AMapNaviViewController的view层级中
 */

/*!
 @brief AMapNaviViewController初始化方法,在传入mapView对象前,需要保存地图当前所有状态,导航SDK会重置mapView的所有状态
 @param mapView MAMapView对象
 @param delegate AMapNaviViewController的代理
 @return AMapNaviViewController类对象id（当AMapNavi.bundle没有正确导入时，返回nil）
 */
- (instancetype)initWithMapView:(MAMapView *)mapView delegate:(id<AMapNaviViewControllerDelegate>)delegate;

#pragma mark - Delegate

/*!
 @brief AMapNaviViewControllerDelegate的代理
 */
@property (nonatomic, weak) id<AMapNaviViewControllerDelegate> delegate;

#pragma mark - Options

/*!
 @brief 导航界面显示模式，默认AMapNaviViewShowModeMapNorthDirection
 */
@property (nonatomic, assign) AMapNaviViewShowMode viewShowMode;

/*!
 @brief 是否显示界面元素，默认YES
 */
@property (nonatomic, assign) BOOL showUIElements;

/*!
 @brief 是否显示指南针，默认NO
 */
@property (nonatomic, assign) BOOL showCompass;

/*!
 @brief 是否显示摄像头，默认YES（只适用于驾车导航）
 */
@property (nonatomic, assign) BOOL showCamera;

/*!
 @brief 是否黑夜模式，默认NO
 */
@property (nonatomic, assign) BOOL showStandardNightType;

/*!
 @brief 是否显示全览按钮，默认YES
 */
@property (nonatomic, assign) BOOL showBrowseRouteButton;

/*!
 @brief 是否显示更多按钮，默认YES
 */
@property (nonatomic, assign) BOOL showMoreButton;

/*!
 @brief 是否显示路况光柱，默认YES（只适用于驾车导航）
 */
@property (nonatomic, assign) BOOL showTrafficBar;

/*!
 @brief 是否显示实时交通按钮，默认YES
 */
@property (nonatomic, assign) BOOL showTrafficButton;

/*!
 @brief 是否显示实时交通图层，默认NO
 */
@property (nonatomic, assign) BOOL showTrafficLayer;

/*!
 @brief 是否显示转向箭头，默认YES
 */
@property (nonatomic, assign) BOOL showTurnArrow;

/*!
 @brief 设置摄像头图标（只适用于驾车导航）
 @param cameraImage 摄像头图标，设置nil为默认图标
 */
- (void)setCameraImage:(UIImage *)cameraImage;

/*!
 @brief 设置路径起点的自定义图标
 @param startPointImage 起点图标，设置nil为默认图标
 */
- (void)setStartPointImage:(UIImage *)startPointImage;

/*!
 @brief 设置路径途经点的自定义图标
 @param wayPointImage 途经点图标，设置nil为默认图标
 */
- (void)setWayPointImage:(UIImage *)wayPointImage;

/*!
 @brief 设置路径终点的自定义图标
 @param endPointImage 终点图标，设置nil为默认图标
 */
- (void)setEndPointImage:(UIImage *)endPointImage;

@end

#pragma mark - AMapNaviViewControllerDelegate

@protocol AMapNaviViewControllerDelegate <NSObject>
@optional

/*!
 @brief 导航界面关闭按钮点击时的回调函数
 */
- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController;

/*!
 @brief 导航界面更多按钮点击时的回调函数
 */
- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController;

/*!
 @brief 导航界面转向指示View点击时的回调函数
 */
- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController;

/*!
 @brief 导航界面进入跟随状态时的回调函数
 */
- (void)naviViewControllerDidChangeToFollowing:(AMapNaviViewController *)naviViewController;

/*!
 @brief 导航界面进入非跟随状态时的回调函数
 */
- (void)naviViewControllerDidChangeToNormal:(AMapNaviViewController *)naviViewController;

@end
