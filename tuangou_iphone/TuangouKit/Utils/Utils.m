//
//  Utils.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/8.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "Utils.h"
#import "dealModel.h"
@implementation Utils

+(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message inController:(UIViewController *)controller withCancleActionHandler:(void (^)(UIAlertAction * _Nonnull))handler withCompletion:(void (^)(void))completion{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    [alert addAction:cancleAction];
    [controller presentViewController:alert animated:YES completion:completion];
}


+(NSString *)getDeviceName{
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    switch (height) {
        case 568:
            return @"5";
            break;
        case 667:
            return @"6";
            break;
        case 736:
            return @"6+";
            break;
        case 480:
            return @"4";
            break;
        default:
            return @"unknown";
            break;
    }
    
}
@end
