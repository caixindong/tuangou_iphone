//
//  AMapNaviLocation.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-7-7.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "AMapNaviCommonObj.h"

/*!
 @brief 当前的自车位置
 */
@interface AMapNaviLocation : NSObject

/*!
 @brief 经纬度
 */
@property (nonatomic, strong) AMapNaviPoint *coordinate;

/*!
 @brief 精确度
 */
@property (nonatomic, assign) double accuracy;

/*!
 @brief 高度
 */
@property (nonatomic, assign) double altitude;

/*!
 @brief 方向
 */
@property (nonatomic, assign) NSInteger heading;

/*!
 @brief 速度(km/h)
 */
@property (nonatomic, assign) NSInteger speed;

/*!
 @brief 时间戳
 */
@property (nonatomic, strong) NSDate *timestamp;

/*!
 @brief 是否匹配在道路上
 */
@property (nonatomic, assign) BOOL isMatchNaviPath;

@end
