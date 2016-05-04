//
//  AMapNaviInfo.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-8-22.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "AMapNaviCommonObj.h"

/*!
 @brief 导航过程中的导航信息
 */
@interface AMapNaviInfo : NSObject<NSCopying,NSCoding>

/*!
 @brief 导航信息更新类型
 */
@property (nonatomic, assign) AMapNaviMode naviMode;

/*!
 @brief 导航段转向图标类型
 */
@property (nonatomic, assign) AMapNaviIconType iconType;

/*!
 @brief 自车方向,单位度(正北为0,顺时针增加)
 */
@property (nonatomic, assign) NSInteger carDirection;

/*!
 @brief 自车经纬度
 */
@property (nonatomic, strong) AMapNaviPoint *carCoordinate;

/*!
 @brief 当前道路名称
 */
@property (nonatomic, strong) NSString *currentRoadName;

/*!
 @brief 下条道路名称
 */
@property (nonatomic, strong) NSString *nextRoadName;

/*!
 @brief 离终点剩余距离,单位米
 */
@property (nonatomic, assign) NSInteger routeRemainDistance;

/*!
 @brief 离终点预估剩余时间,单位秒
 */
@property (nonatomic, assign) NSInteger routeRemainTime;

/*!
 @brief 当前路段剩余距离,单位米
 */
@property (nonatomic, assign) NSInteger segmentRemainDistance;

/*!
 @brief 当前路段预估剩余时间,单位秒
 */
@property (nonatomic, assign) NSInteger segmentRemainTime;


/// 以下导航信息仅在驾车导航时有效

/*!
 @brief 电子眼距离,单位米(-1为没有电子眼或距离很远)
 */
@property (nonatomic, assign) NSInteger cameraDistance;

/*!
 @brief 电子眼类型(0为测速摄像头,1为监控摄像头)
 */
@property (nonatomic, assign) NSInteger cameraType;

/*!
 @brief 电子眼经纬度
 */
@property (nonatomic, strong) AMapNaviPoint *cameraCoordinate;

/*!
 @brief 电子眼限速(0为无限速信息)
 */
@property (nonatomic, assign) NSInteger cameraLimitSpeed;

/*!
 @brief 离服务站距离,单位米(-1为没有服务站)
 */
@property (nonatomic, assign) NSInteger serviceAreaDistance;

@end
