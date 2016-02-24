//
//  Cities.m
//  团购项目
//
//  Created by 蔡欣东 on 15/9/10.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import "Cities.h"

@implementation Cities
+(NSArray *)getCities{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil];
    NSArray* plistArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray* modelArr = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in plistArray) {
        Cities* cityModel = [[Cities alloc]init];
        cityModel.name = [dict objectForKey:@"name"];
        cityModel.pinYin = [dict objectForKey:@"pinYin"];
        cityModel.pinYinHead = [dict objectForKey:@"pinYinHead"];
        cityModel.region = [dict objectForKey:@"region"];
        [modelArr addObject:cityModel];
    }
    return modelArr;
}
@end
