//
//  Utils.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/8.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
/**
 简单弹窗
 **/
+(void)showAlertViewWithTitle:(nullable NSString *)title andMessage:(nullable NSString *)message inController:( UIViewController* _Nonnull )controller withCancleActionHandler:(void (^ __nullable)(UIAlertAction* _Nonnull action))handler withCompletion:(void (^ __nullable)(void))completion;
/**
 收藏功能实现
 **/
+(NSArray*_Nonnull)getCollection;
+(void)addObjectToCollection:(id _Nonnull)obj;
+(void)removeObjectFromCollection:(id _Nonnull)obj;
/**
 订单功能实现
 **/
+(NSArray*_Nonnull)getDeals;
+(void)addObjectToDeals:(id _Nonnull)obj;
+(void)removeObjectFromDeals:(id _Nonnull)obj;
@end
