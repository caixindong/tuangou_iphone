//
//  AMapNaviHUDViewController.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-8-17.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMapNaviCommonObj.h"

@protocol AMapNaviHUDViewControllerDelegate;

/*!
 @brief HUD视图控制器,需调用AMapNaviManager的presentNaviViewController:animated:方法进行展示
 */
@interface AMapNaviHUDViewController : UIViewController

#pragma mark - Initialization

/*!
 @brief AMapNaviHUDViewController初始化方法
 @param delegate AMapNaviHUDViewController的代理
 @return AMapNaviHUDViewController类对象id（当AMapNavi.bundle没有正确导入时，返回nil）
 */
- (instancetype)initWithDelegate:(id<AMapNaviHUDViewControllerDelegate>)delegate;

#pragma mark - Delegate

/*!
 @brief AMapNaviHUDViewController的代理
 */
@property (nonatomic, weak) id<AMapNaviHUDViewControllerDelegate> delegate;

#pragma mark - Options

/*!
 @brief 是否以镜像的方式显示，默认YES
 */
@property (nonatomic, assign) BOOL isMirror;

/*!
 @brief 是否显示剩余距离，默认YES
 */
@property (nonatomic, assign) BOOL showRemainDistance;

/*!
 @brief 是否显示剩余时间，默认YES
 */
@property (nonatomic, assign) BOOL showRemainTime;

@end

#pragma mark - AMapNaviHUDViewControllerDelegate

@protocol AMapNaviHUDViewControllerDelegate <NSObject>
@optional

/*!
 @brief HUD界面返回按钮点击时的回调函数
 */
- (void)naviHUDViewControllerBackButtonClicked:(AMapNaviHUDViewController *)naviHUDViewController;

@end
