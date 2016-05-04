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
 获取设备型号
 **/
+(NSString*_Nonnull)getDeviceName;
@end
