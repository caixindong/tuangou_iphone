//
//  AMapLocationManager.h
//  AMapLocationKit
//
//  Created by AutoNavi on 15/10/22.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AMapLocationCommonObj.h"

/**
 *  AMapLocatingCompletionBlock 单次定位返回Block
 *
 *  @param location 定位信息
 *  @param regeocode 逆地理信息
 *  @param error 错误信息，参考 AMapLocationErrorCode
 */
typedef void (^AMapLocatingCompletionBlock)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error);

@protocol AMapLocationManagerDelegate;

#pragma mark - AMapLocationManager

/**
 *  AMapLocationManager类
 *
 *  初始化之前请设置 AMapLocationServices 中的APIKey，否则将无法正常使用服务.
 */
@interface AMapLocationManager : NSObject

/**
 * 实现了 AMapLocationManagerDelegate 协议的类指针。
 */
@property (nonatomic, weak) id<AMapLocationManagerDelegate> delegate;

/**
 * 设定定位的最小更新距离。默认为 kCLDistanceFilterNone 。
 */
@property(nonatomic, assign) CLLocationDistance distanceFilter;

/**
 * 设定定位精度。默认为 kCLLocationAccuracyBest 。
 */
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/**
 * 指定定位是否会被系统自动暂停。默认为YES。
 */
@property(nonatomic, assign) BOOL pausesLocationUpdatesAutomatically;

/**
 * 是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。
 *
 * 设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
 */
@property(nonatomic, assign) BOOL allowsBackgroundLocationUpdates;

/**
 *  单次定位
 *
 *  如果当前正在连续定位，调用此方法将会失败，返回NO。
 *
 *  该方法将会根据设定的 desiredAccuracy 去获取定位信息。
 *  如果获取的定位信息精确度低于 desiredAccuracy ，将会持续的等待定位信息，直到超时后通过completionBlock返回精度最高的定位信息。
 *
 *  可以通过 stopUpdatingLocation 方法去取消正在进行的单次定位请求。
 *
 *  @param withReGeocode 是否带有逆地理信息(获取逆地理信息需要联网)
 *  @param completionBlock 单次定位完成后的Block
 *  @return 是否成功添加单次定位Request
 */
- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock;

/**
 *  开始连续定位
 *
 *  调用此方法会cancel掉所有的单次定位请求
 */
- (void)startUpdatingLocation;

/**
 *  停止连续定位
 *
 *  调用此方法会cancel掉所有的单次定位请求，可以用来取消单次定位。
 */
- (void)stopUpdatingLocation;

@end

#pragma mark - AMapLocationManagerDelegate

/**
 *  AMapLocationManagerDelegate 协议
 *
 *  定义了发生错误时的错误回调方法，连续定位的回调方法等。
 */
@protocol AMapLocationManagerDelegate <NSObject>
@optional

/**
 *  当定位发生错误时，会调用代理的此方法。
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error;

/**
 *  连续定位回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location;

@end
