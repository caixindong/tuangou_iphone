//
//  AMapNaviManager.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-8-15.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "AMapNaviCommonObj.h"

@class AMapNaviInfo;
@class AMapNaviRoute;
@class AMapNaviLocation;
@protocol AMapNaviManagerDelegate;

#pragma mark - AMapNaviManager

@interface AMapNaviManager : NSObject

#pragma mark - Delegate

/*!
 @brief AMapNaviManager的代理
 */
@property (nonatomic, weak) id<AMapNaviManagerDelegate> delegate;

#pragma mark - NaviViewController

/*!
 @brief 展示导视图控制器
 @param naviViewController 仅支持AMapNaviViewController实例和AMapNaviHUDViewController实例。如果要展示AMapNaviViewController，需要提前保存地图当前所有状态,导航SDK会重置mapView的所有状态
 */
- (void)presentNaviViewController:(UIViewController *)naviViewController animated:(BOOL)animated;

/*!
 @brief 取消展示导航视图控制器
 */
- (void)dismissNaviViewControllerAnimated:(BOOL)animated;

#pragma mark - Navi Info

/*!
 @brief 当前导航路径的信息
 */
@property (nonatomic, readonly) AMapNaviRoute *naviRoute;

/*!
 @brief 当前导航模式
 */
@property (nonatomic, readonly) AMapNaviMode naviMode;

#pragma mark - Options

/*!
 @brief 是否播报摄像头信息，默认YES（只适用于驾车导航）
 */
@property (nonatomic, assign) BOOL updateCameraInfo;

/*!
 @brief 偏航时是否重新计算路径，默认YES（计算路径需要联网）
 */
@property (nonatomic, assign) BOOL isRecalculateRouteForYaw;

/*!
 @brief 是否在导航过程中让屏幕常亮，默认YES
 */
@property (nonatomic, assign) BOOL screenAlwaysBright;

/*!
 @brief 是否播报交通信息，默认YES（只适用于驾车导航，需要联网）
 */
@property (nonatomic, assign) BOOL updateTrafficInfo;

/*!
 @brief 智能播报，默认为AMapDetecteModeNone（需要联网）
 @brief 智能播报适用于不设置目的驾车过程中，播报电子眼、特殊道路设施等信息
 */
@property (nonatomic, assign) AMapNaviDetectedMode detectedMode;

/*!
 @brief 是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。
 @brief 设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
 */
@property (nonatomic, assign) BOOL allowsBackgroundLocationUpdates;

#pragma mark - Calculate Route

///以下算路方法需要高德地图坐标

#pragma mark Drive
/*!
 @brief 不带起点的驾车路径计算
 @param endPoints 终点坐标。支持多个终点，终点列表的尾点为实际导航终点，其他坐标点为辅助信息，带有方向性，可有效避免算路到马路的另一侧。
 @param wayPoints 途经点坐标序列，同时支持最多3个途经点的路径规划。
 @param strategy  驾车路径的计算策略
 @return 路径是否计算成功
 */
- (BOOL)calculateDriveRouteWithEndPoints:(NSArray *)endPoints
                               wayPoints:(NSArray *)wayPoints
                         drivingStrategy:(AMapNaviDrivingStrategy)strategy;

/*!
 @brief 带起点的驾车路径计算
 @param startPoints 起点坐标。支持多个起点，起点列表的尾点为实际导航起点，其他坐标点为辅助信息，带有方向性，可有效避免算路到马路的另一侧。
 @param endPoints   终点坐标。支持多个终点，终点列表的尾点为实际导航终点，其他坐标点为辅助信息，带有方向性，可有效避免算路到马路的另一侧。
 @param wayPoints   途经点坐标序列，同时支持最多3个途经点的路径规划。
 @param strategy    驾车路径的计算策略
 @return 路径是否计算成功
 */
- (BOOL)calculateDriveRouteWithStartPoints:(NSArray *)startPoints
                                 endPoints:(NSArray *)endPoints
                                 wayPoints:(NSArray *)wayPoints
                           drivingStrategy:(AMapNaviDrivingStrategy)strategy;

/*!
 @brief 导航过程中重新规划路线(起点为当前位置，途经点、终点位置不变，只适用于驾车导航)
 @param strategy 驾车路径的计算策略
 @return 路径是否计算成功
 */
- (BOOL)recalculateDriveRouteWithDrivingStrategy:(AMapNaviDrivingStrategy)strategy;

#pragma mark Walk
/*!
 @brief 不带起点的步行路径计算
 @param endPoints 终点坐标。支持多个终点，终点列表的尾点为实际导航终点，其他坐标点为辅助信息，带有方向性，可有效避免算路到马路的另一侧。
 @return 路径是否计算成功
 */
- (BOOL)calculateWalkRouteWithEndPoints:(NSArray *)endPoints;

/*!
 @brief 带起点的步行路径计算
 @param startPoints 起点坐标。支持多个起点，起点列表的尾点为实际导航起点，其他坐标点为辅助信息，带有方向性，可有效避免算路到马路的另一侧。
 @param endPoints   终点坐标。支持多个终点，终点列表的尾点为实际导航终点，其他坐标点为辅助信息，带有方向性，可有效避免算路到马路的另一侧。
 @return 路径是否计算成功
 */
- (BOOL)calculateWalkRouteWithStartPoints:(NSArray *)startPoints
                                endPoints:(NSArray *)endPoints;

/*!
 @brief 导航过程中重新规划路线(起点为当前位置，终点位置不变，只适用于步行导航)
 @return 路径是否计算成功
 */
- (BOOL)recalculateWalkRoute;

#pragma mark - Navi Guide

/*!
 @brief 获取导航路线的路线详情列表
 @return AMapNaviGuide数组，导航路线的路线详情列表
 */
- (NSArray *)getNaviGuideList;

#pragma mark - GPS & Emulator Navi

/*!
 @brief 设置模拟导航的速度,默认60
 @param speed 模拟导航的速度(范围:[10,120]; 单位:km/h)
 */
- (void)setEmulatorNaviSpeed:(int)speed;

/*!
 @brief 开始模拟导航
 @return 是否成功
 */
- (BOOL)startEmulatorNavi;

/*!
 @brief 开始实时导航
 @return 是否成功
 */
- (BOOL)startGPSNavi;

/*!
 @brief 停止导航，包含实时导航和模拟导航
 */
- (void)stopNavi;

/*!
 @brief 暂停导航，包含实时导航和模拟导航
 */
- (void)pauseNavi;

/*!
 @brief 继续导航，包含实时导航和模拟导航
 */
- (void)resumeNavi;

#pragma mark - Manual

/*!
 @brief 设置TTS语音播报每播报一个字需要的时间。 根据播报一个字的时间和运行的速度，可以更改语音播报的触发时机。
 @param time 每个字的播放时间(范围:[250,500]; 单位:毫秒)
 */
- (void)setTimeForOneWord:(int)time;

/*!
 @brief 触发一次导航播报信息
 @return 是否成功
 */
- (BOOL)readNaviInfoManual;

/*!
 @brief 手动刷新路况信息，调用后会刷新路况光柱。（只适用于驾车导航，SDK每四分钟自动刷新一次，但限制两次刷新的最小时间间隔为一分钟）
 */
- (void)refreshTrafficStatusesManual;

#pragma mark - Traffic Status

/*!
 @brief 获取某一范围内的路况光柱信息。（只适用于驾车导航）
 @param startPosition 光柱范围在路径中的起始位置，取值范围[0, routeLength)
 @param distance 光柱范围的距离，startPosition + distance 和的取值范围(0, routelength]
 @return AMapNaviTrafficStatus数组，该范围内路况信息数组，可用于绘制光柱
 */
- (NSArray *)getTrafficStatusesWithStartPosition:(int)startPosition distance:(int)distance;

@end

#pragma mark - AMapNaviManagerDelegate

@protocol AMapNaviManagerDelegate <NSObject>
@optional

/*!
 @brief AMapNaviManager发生错误时的回调函数
 @param error 错误信息
 */
- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error;

/*!
 @brief naviViewController被展示出来后的回调
 @param naviViewController 被展示出来的ViewController
 */
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController;

/*!
 @brief naviViewController被取消展示后的回调
 @param naviViewController 被取消展示ViewController
 */
- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController;

/*!
 @brief 驾车路径规划成功后的回调函数
 */
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager;

/*!
 @brief 驾车路径规划失败后的回调函数
 @param error 计算路径的错误，error.code参照AMapNaviCalcRouteState
 */
- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error;

/*!
 @brief 驾车导航时，出现偏航需要重新计算路径时的回调函数
 */
- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager;

/*!
 @brief 启动导航后回调函数
 @param naviMode 导航类型，参考AMapNaviMode
 */
- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode;

/*!
 @brief 模拟导航到达目的地停止导航后的回调函数
 */
- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager;

/*!
 @brief 到达目的地后回调
 */
- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager;

/*!
 @brief 驾车路径导航到达某个途经点的回调函数
 @param wayPointIndex 到达途径点的编号，标号从1开始
 */
- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex;

/*!
 @brief 自车位置更新后的回调函数
 @param naviLocation 当前自车位置信息
 */
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation;

/*!
 @brief 模拟和GPS导航过程中,导航信息有更新后的回调函数
 @param naviInfo 当前的导航信息
 */
- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo;

/*!
 @brief 获取当前播报状态的回调函数
 @return 返回当前是否正在播报
 */
- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager;

/*!
 @brief 导航播报信息回调函数
 @param soundString 播报文字
 @param soundStringType 播报类型，包含导航播报、前方路况播报和整体路况播报，参考AMapNaviSoundType
 */
- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType;

/*!
 @brief 当前方路况光柱信息更新后的回调函数
 */
- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager;

@end
