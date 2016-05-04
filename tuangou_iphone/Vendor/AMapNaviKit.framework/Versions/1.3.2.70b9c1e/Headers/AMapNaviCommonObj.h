//
//  AMapNaviCommonObj.h
//  AMapNaviTest
//
//  Created by 刘博 on 14-7-1.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief AMapNavi的错误Domain
 */
extern NSString * const AMapNaviErrorDomain;

/*!
 @brief AMapNavi的错误信息
 */
typedef NS_ENUM(NSInteger, AMapNaviError)
{
    AMapNaviUnknowError = -1,                   //未知错误
    AMapNaviErrorNoGPSPermission = -2,          //没有GPS权限
    AMapNaviErrorViewControllerExisting = -3,   //已经存在展示出的视图控制器
};

/*!
 @brief 导航模式
 */
typedef NS_ENUM(NSInteger, AMapNaviMode)
{
    AMapNaviModeNone = 0,                       //没有开始导航
    AMapNaviModeGPS,                            //GPS导航
    AMapNaviModeEmulator,                       //模拟导航
};

/*!
 @brief 导航界面显示模式
 */
typedef NS_ENUM(NSInteger, AMapNaviViewShowMode)
{
    AMapNaviViewShowModeMapNorthDirection = 0,      //0 地图朝北
    AMapNaviViewShowModeCarNorthDirection,          //1 车头朝北
};

/*!
 @brief 驾车策略
 */
typedef NS_ENUM(NSInteger, AMapNaviDrivingStrategy)
{
    AMapNaviDrivingStrategyDefault = 0,             //0 速度优先
    AMapNaviDrivingStrategySaveMoney = 1,           //1 费用优先
    AMapNaviDrivingStrategyShortDistance = 2,       //2 距离优先
    AMapNaviDrivingStrategyNoExpressways = 3,       //3 普通路优先（不走快速路、高速路）
    AMapNaviDrivingStrategyFastestTime = 4,         //4 时间优先，躲避拥堵
    AMapNaviDrivingStrategyAvoidCongestion = 12,    //12 躲避拥堵且不走收费道路.注意：当选择驾车策略12（躲避拥堵且不走收费道路）进行路径规划时，返回的策略值为4（时间优先，躲避拥堵）
};

/*!
 @brief 路径计算状态
 */
typedef NS_ENUM(NSInteger, AMapNaviCalcRouteState)
{
    AMapNaviCalcRouteStateSucceed = 1,              //1 路径计算成功
    AMapNaviCalcRouteStateNetworkError,             //2 网络超时或网络失败
    AMapNaviCalcRouteStateStartPointError,          //3 起点错误
    AMapNaviCalcRouteStateProtocolError,            //4 协议解析错误
    AMapNaviCalcRouteStateEndPointError = 6,        //6 终点错误
    AMapNaviCalcRouteStateStartRouteError = 10,     //10 起点没有找到道路
    AMapNaviCalcRouteStateEndRouteError = 11,       //11 没有找到通向终点的道路
    AMapNaviCalcRouteStatePassRouteError = 12,      //12 没有找到通向途经点的道路
    AMapNaviCalcRouteStateRouteLengthOverLimit = 13,//13 路径长度超过限制
    AMapNaviCalcRouteStateUnknowError,              //其他错误
};

/*!
 @brief 导航段转向图标类型
 */
typedef NS_ENUM(NSInteger, AMapNaviIconType)
{
    AMapNaviIconTypeNone = 0,                       //0 无定义
    AMapNaviIconTypeDefault,                        //1 车图标
    AMapNaviIconTypeLeft,                           //2 左转图标
    AMapNaviIconTypeRight,                          //3 右转图标
    AMapNaviIconTypeLeftFront,                      //4 左前方图标
    AMapNaviIconTypeRightFront,                     //5 右前方图标
    AMapNaviIconTypeLeftBack,                       //6 左后方图标
    AMapNaviIconTypeRightBack,                      //7 右后方图标
    AMapNaviIconTypeLeftAndAround,                  //8 左转掉头图标
    AMapNaviIconTypeStraight,                       //9 直行图标
    AMapNaviIconTypeArrivedWayPoint,                //10 到达途经点图标
    AMapNaviIconTypeEnterRoundabout,                //11 进入环岛图标
    AMapNaviIconTypeOutRoundabout,                  //12 驶出环岛图标
    AMapNaviIconTypeArrivedServiceArea,             //13 到达服务区图标
    AMapNaviIconTypeArrivedTollGate,                //14 到达收费站图标
    AMapNaviIconTypeArrivedDestination,             //15 到达目的地图标
    AMapNaviIconTypeArrivedTunnel,                  //16 进入隧道图标
    AMapNaviIconTypeCrosswalk,                      //17 通过人行横道图标
    AMapNaviIconTypeFlyover,                        //18 通过过街天桥图标
    AMapNaviIconTypeUnderpass,                      //19 通过地下通道图标
};

/*!
 @brief 导航播报类型
 */
typedef NS_ENUM(NSInteger, AMapNaviSoundType)
{
    AMapNaviSoundTypeNaviInfo = 1,                  //1 导航播报
    AMapNaviSoundTypeFrontTraffic = 2,              //2 前方路况
    AMapNaviSoundTypeSurroundingTraffic = 4,        //4 周边路况
    AMapNaviSoundTypePassedReminder = 8,            //8 通过提示
};

/*!
 @brief 非导航状态电子眼播报类型
 */
typedef NS_ENUM(NSInteger,AMapNaviDetectedMode)
{
    AMapNaviDetectedModeNone = 0,                   //0 关闭所有
    AMapNaviDetectedModeCamera,                     //1 仅电子眼
    AMapNaviDetectedModeSpecialRoad,                //2 仅特殊道路设施
    AMapNaviDetectedModeCameraAndSpecialRoad,       //3 电子眼和特殊道路设施
};

#pragma mark - AMapNaviPoint

/*!
 @brief 经纬度
 */
@interface AMapNaviPoint : NSObject<NSCopying,NSCoding>

/*!
 @brief 纬度
 */
@property (nonatomic, assign) CGFloat latitude;

/*!
 @brief 经度
 */
@property (nonatomic, assign) CGFloat longitude;

/*!
 @brief AMapNaviPoint类对象的初始化函数
 @param lat 纬度
 @param lon 经度
 @return AMapNaviPoint类对象id
 */
+ (AMapNaviPoint *)locationWithLatitude:(CGFloat)lat longitude:(CGFloat)lon;

@end

#pragma mark - AMapNaviPointBounds

@interface AMapNaviPointBounds : NSObject<NSCopying,NSCoding>

/*!
 @brief 东北角坐标
 */
@property (nonatomic, strong) AMapNaviPoint *northEast;

/*!
 @brief 西南角坐标
 */
@property (nonatomic, strong) AMapNaviPoint *southWest;

/*!
 @brief AMapNaviPointBounds类对象的初始化函数
 @param northEast 东北角经纬度
 @param southWest 西南角经纬度
 @return AMapNaviPointBounds类对象id
 */
+ (AMapNaviPointBounds *)pointBoundsWithNorthEast:(AMapNaviPoint *)northEast southWest:(AMapNaviPoint *)southWest;

@end

#pragma mark - AMapNaviGuide

/*!
 @brief 导航段信息类
 */
@interface AMapNaviGuide : NSObject<NSCopying,NSCoding>

/*!
 @brief 导航段名称
 */
@property (nonatomic, strong) NSString *name;

/*!
 @brief 导航段长度
 */
@property (nonatomic, assign) NSInteger length;

/*!
 @brief 导航段时间
 */
@property (nonatomic, assign) NSInteger time;

/*!
 @brief 导航段转向类型
 */
@property (nonatomic, assign) AMapNaviIconType iconType;

/*!
 @brief 导航段路口点的坐标
 */
@property (nonatomic, strong) AMapNaviPoint *coordinate;

@end

#pragma mark - AMapNaviTrafficStatus

/*!
 @brief 前方交通路况信息类，即路况光柱信息类
 */
@interface AMapNaviTrafficStatus : NSObject

/*!
 @brief 交通状态
 @brief 0-未知状态，1-通畅，2-缓行，3-阻塞，4-严重阻塞
 */
@property (nonatomic, assign) NSInteger status;

/*!
 @brief 该交通状态的路段长度
 */
@property (nonatomic, assign) NSInteger length;

@end
