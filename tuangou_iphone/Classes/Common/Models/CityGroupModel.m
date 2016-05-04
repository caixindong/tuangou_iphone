//
//  CityGroupModel.m
//  团购项目
//
//  Created by 蔡欣东 on 15/9/9.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import "CityGroupModel.h"

@implementation CityGroupModel{
    NSArray* _plistArray;
}
-(instancetype)init{
    if (self=[super init]) {
        [self loadPlist];
    }
    return self;
}
-(void)loadPlist{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"cityGroups.plist" ofType:nil];
    _plistArray = [NSArray arrayWithContentsOfFile:path];
}
-(NSArray*)getModelArray{
    NSMutableArray* Arr = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in _plistArray) {
        CityGroupModel* model = [[CityGroupModel alloc]init];
        model.title = [dict objectForKey:@"title"];
        model.cities = [dict objectForKey:@"cities"];
        [Arr addObject:model];
    }
    return Arr;
}
@end
