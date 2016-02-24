//
//  dealModel.h
//  团购项目
//
//  Created by 蔡欣东 on 15/9/12.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dealModel : NSObject
/*
 将从服务器拿来的数据转化为model
 */

//商品分类
@property(nonatomic,copy)NSString* categories;
@property(nonatomic,copy)NSString* city;

@property(nonatomic,copy)NSString* current_price;

@property(nonatomic,copy)NSString* deal_h5_url;

@property(nonatomic,copy)NSString* deal_url;
@property(nonatomic,copy)NSString* Description;
@property(nonatomic,copy)NSString* image_url;
@property(nonatomic,copy)NSString* s_image_url;
@property(nonatomic,copy)NSString* list_price;
@property(nonatomic,copy)NSString* purchase_deadline;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* purchase_count;
@property(nonatomic,copy)NSString* deal_id;
@property(nonatomic,copy)NSString* businesses_id;
@property(nonatomic,assign)float businesses_latitude;
@property(nonatomic,assign)float businesses_longitude;

-(NSArray*)asignModelWithDict:(NSDictionary*) dict;
@end
