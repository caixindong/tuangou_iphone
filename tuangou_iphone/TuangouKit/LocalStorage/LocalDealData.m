//
//  LocalDealData.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 16/5/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "LocalDealData.h"

@implementation LocalDealData

+(NSArray *)getDeals{
    NSArray* arr = [[MyUserDefault shareUserDefault] valueWithKey:deals];
    if (arr!=nil) {
        return arr;
    }else{
        return @[];
        
    }
}
+(void)addObjectToDeals:(id)obj{
    NSArray* arr = [LocalDealData getDeals];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    [newArr addObject:obj];
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:deals];
}
+(void)removeObjectFromDeals:(id)obj{
    NSArray* arr = [LocalDealData getDeals];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    if ([newArr containsObject:obj]) {
        [newArr removeObject:obj];
    }
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:deals];
}
@end
