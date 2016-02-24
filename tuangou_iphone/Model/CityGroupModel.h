//
//  CityGroupModel.h
//  团购项目
//
//  Created by 蔡欣东 on 15/9/9.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityGroupModel : NSObject
@property(nonatomic,strong)NSArray* cities;
@property(nonatomic,copy)NSString* title;

-(NSArray*)getModelArray;
@end
