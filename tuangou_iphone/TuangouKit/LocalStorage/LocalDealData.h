//
//  LocalDealData.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 16/5/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDealData : NSObject
/**
 订单功能实现
 **/
+(NSArray*_Nonnull)getDeals;
+(void)addObjectToDeals:(id _Nonnull)obj;
+(void)removeObjectFromDeals:(id _Nonnull)obj;

@end
