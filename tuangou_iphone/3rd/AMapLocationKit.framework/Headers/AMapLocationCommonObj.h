//
//  AMapLocationCommonObj.h
//  AMapLocationKit
//
//  Created by AutoNavi on 15/10/22.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

/** AMapLocation errorDomain */
extern NSString * const AMapLocationErrorDomain;

/** AMapLocation errorCode */
typedef NS_ENUM(NSInteger, AMapLocationErrorCode)
{
    AMapLocationErrorUnknown = 1,               //!< 未知错误
    AMapLocationErrorLocateFailed = 2,          //!< 定位错误
    AMapLocationErrorReGeocodeFailed  = 3,      //!< 逆地理错误
    AMapLocationErrorTimeOut = 4,               //!< 超时
    AMapLocationErrorCanceled = 5,              //!< 取消
    AMapLocationErrorCannotFindHost = 6,        //!< 找不到主机
    AMapLocationErrorBadURL = 7,                //!< URL异常
    AMapLocationErrorNotConnectedToInternet = 8,//!< 连接异常
    AMapLocationErrorCannotConnectToHost = 9,   //!< 服务器连接失败
};

/**
 * 逆地理信息
 */
@interface AMapLocationReGeocode : NSObject<NSCopying,NSCoding>

@property (nonatomic, copy) NSString *formattedAddress;//!< 格式化地址
@property (nonatomic, copy) NSString *province; //!< 省/直辖市
@property (nonatomic, copy) NSString *city;     //!< 市
@property (nonatomic, copy) NSString *district; //!< 区
@property (nonatomic, copy) NSString *citycode; //!< 城市编码
@property (nonatomic, copy) NSString *adcode;   //!< 区域编码

@end
