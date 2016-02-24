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

+(NSArray *)getCollection{
    NSArray* arr = [[MyUserDefault shareUserDefault] valueWithKey:collection1];
    if (arr!=nil) {
        return arr;
    }else{
        return @[];
    }
}
+(void)addObjectToCollection:(id)obj{
    NSArray* arr = [Utils getCollection];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    if ([newArr containsObject:obj]) {
        [newArr removeObject:obj];
    }
    [newArr addObject:obj];
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:collection1];
}
+(void)removeObjectFromCollection:(id)obj{
    NSArray* arr = [Utils getCollection];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    if ([newArr containsObject:obj]) {
        [newArr removeObject:obj];
    }
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:collection1];
}

+(NSArray *)getDeals{
    NSArray* arr = [[MyUserDefault shareUserDefault] valueWithKey:deals];
    if (arr!=nil) {
        return arr;
    }else{
        return @[];
        
    }
}
+(void)addObjectToDeals:(id)obj{
    NSArray* arr = [Utils getDeals];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    [newArr addObject:obj];
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:deals];
}
+(void)removeObjectFromDeals:(id)obj{
    NSArray* arr = [Utils getDeals];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    if ([newArr containsObject:obj]) {
        [newArr removeObject:obj];
    }
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:deals];
}
@end
