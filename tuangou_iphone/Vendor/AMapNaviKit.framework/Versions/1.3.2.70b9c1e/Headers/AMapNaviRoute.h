//
//  AMapNaviRoute.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-7-11.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMapNaviCommonObj.h"

/*!
 @brief 导航路径信息
 */
@interface AMapNaviRoute : NSObject<NSCopying>

/*!
 @brief 导航路径总长度(单位：米)
 */
@property (nonatomic, assign) int routeLength;

/*!
 @brief 导航路径所需的时间(单位：秒)
 */
@property (nonatomic, assign) int routeTime;

/*!
 @brief 导航路线最小坐标点和最大坐标点围成的矩形区域
 */
@property (nonatomic, strong) AMapNaviPointBounds *routeBounds;

/*!
 @brief 导航路线的中心点，即导航路径的最小外接矩形对角线的交点。
 */
@property (nonatomic, strong) AMapNaviPoint *routeCenterPoint;

/*!
 @brief AMapNaviPoint数组，导航路线的所有形状点
 */
@property (nonatomic, strong) NSArray *routeCoordinates;

/*!
 @brief 路线方案的起点坐标
 */
@property (nonatomic, strong) AMapNaviPoint *routeStartPoint;

/*!
 @brief 路线方案的终点坐标
 */
@property (nonatomic, strong) AMapNaviPoint *routeEndPoint;

/*!
 @brief 导航路线上分段的总数
 */
@property (nonatomic, assign) int routeSegmentCount;

/*!
 @brief 导航路线上红绿灯的总数
 */
@property (nonatomic, assign) int routeTrafficLightCount;

/*!
 @brief 导航路线的路径计算策略（只适用于驾车导航）
 */
@property (nonatomic, assign) AMapNaviDrivingStrategy routeStrategy;

/*!
 @brief 导航路线的花费金额(单位：元)
 */
@property (nonatomic, assign) int routeTollCost;

/*!
 @brief AMapNaviPoint数组，路径的途经点坐标
 */
@property (nonatomic, strong) NSArray *wayPoints;

@end
