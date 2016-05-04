//
//  CategoriyModel.h
//  团购项目
//
//  Created by 蔡欣东 on 15/9/9.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoriyModel : NSObject
//名称
@property(copy,nonatomic)NSString* name;
//子数据数组
@property(strong,nonatomic)NSArray* subcategories;

-(NSArray*)loadPlistData;

@end
