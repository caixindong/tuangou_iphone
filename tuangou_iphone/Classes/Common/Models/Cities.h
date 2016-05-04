//
//  Cities.h
//  团购项目
//
//  Created by 蔡欣东 on 15/9/10.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cities : NSObject
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* pinYin;
@property(nonatomic,copy)NSString*  pinYinHead;
@property(nonatomic,strong)NSArray* region;

+(NSArray*)getCities;

@end
