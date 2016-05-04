//
//  CollectionData.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 16/5/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "CollectionData.h"

@implementation CollectionData
+(NSArray *)getCollection{
    NSArray* arr = [[MyUserDefault shareUserDefault] valueWithKey:collection1];
    if (arr!=nil) {
        return arr;
    }else{
        return @[];
    }
}
+(void)addObjectToCollection:(id)obj{
    NSArray* arr = [CollectionData getCollection];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    if ([newArr containsObject:obj]) {
        [newArr removeObject:obj];
    }
    [newArr addObject:obj];
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:collection1];
}
+(void)removeObjectFromCollection:(id)obj{
    NSArray* arr = [CollectionData getCollection];
    NSMutableArray* newArr = [NSMutableArray arrayWithArray:arr];
    if ([newArr containsObject:obj]) {
        [newArr removeObject:obj];
    }
    [[MyUserDefault shareUserDefault]storeValue:(NSArray*)newArr withKey:collection1];
}
@end
