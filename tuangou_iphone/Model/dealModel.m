//
//  dealModel.m
//  团购项目
//
//  Created by 蔡欣东 on 15/9/12.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import "dealModel.h"

@implementation dealModel

-(NSArray *)asignModelWithDict:(NSDictionary *)dict{
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    NSArray* dictArray = [dict objectForKey:@"deals"];
    for (NSDictionary* dict in dictArray) {
        dealModel* md = [[dealModel alloc]init];
        
        md.categories = dict[@"categories"];
        md.city = dict[@"city"];
        md.current_price = [dict[@"current_price"] stringValue];
        md.deal_h5_url = dict[@"deal_h5_url"];
        md.deal_url = dict[@"deal_url"];
        md.Description = dict[@"description"];
        md.image_url = dict[@"image_url"];
        md.s_image_url = dict[@"s_image_url"];
        md.list_price = [dict[@"list_price"] stringValue];
        md.purchase_deadline = dict[@"purchase_deadline"];
        md.title = dict[@"title"];
        md.purchase_count = [dict[@"purchase_count"] stringValue];
        md.deal_id = dict[@"deal_id"];
        NSArray* businesses = dict[@"businesses"];
        if (businesses.count>0) {
            NSDictionary* businessInf = businesses[0];
            md.businesses_id = businessInf[@"id"];
            md.businesses_latitude = [businessInf[@"latitude"] floatValue];
            md.businesses_longitude = [businessInf[@"longitude"] floatValue];
        }
        [arr addObject:md];
    }
    return arr;
}

@end
