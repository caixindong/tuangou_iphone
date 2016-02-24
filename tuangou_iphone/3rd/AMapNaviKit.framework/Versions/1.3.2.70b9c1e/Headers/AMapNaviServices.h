//
//  AMapNaviServices.h
//  AMapNaviKit
//
//  Created by 刘博 on 14-7-22.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMapNaviServices : NSObject

+ (AMapNaviServices *)sharedServices;

/*!
 @brief API Key, 在创建AMapNaviViewController之前需要先绑定key.
 */
@property (nonatomic, copy) NSString *apiKey;

/*!
 @brief SDK 版本号，形式如"v1.3.1"
 */
@property (nonatomic, readonly) NSString *SDKVersion;

@end
