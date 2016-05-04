//
//  CategoriyModel.m
//  团购项目
//
//  Created by 蔡欣东 on 15/9/9.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import "CategoriyModel.h"

@implementation CategoriyModel
//加载plist文件
-(NSArray*)loadPlistData{
    NSString* file = [[NSBundle mainBundle]pathForResource:@"categories.plist" ofType:nil];
    NSLog(@"%@",file);
    NSArray* plistArray = [NSArray arrayWithContentsOfFile:file];
    return [self getDataWithArray:plistArray];

}

//解析
-(NSArray*)getDataWithArray:(NSArray*) array{
    NSMutableArray* Arr = [[NSMutableArray alloc]init];
    for (NSDictionary* dict in array) {
        CategoriyModel* md = [[CategoriyModel alloc]init];
        [md makeModelWithDict:dict];
        [Arr addObject:md];
    }
    return Arr;
    
}

//字典转模型
-(CategoriyModel*)makeModelWithDict:(NSDictionary*)dict{
    self.name = [dict objectForKey:@"name"];
    self.subcategories = [dict objectForKey:@"subcategories"];
    return self;
}


@end
