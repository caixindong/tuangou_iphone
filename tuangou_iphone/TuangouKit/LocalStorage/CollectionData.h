//
//  CollectionData.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 16/5/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionData : NSObject

+(NSArray *)getCollection;
+(void)addObjectToCollection:(id)obj;
+(void)removeObjectFromCollection:(id)obj;
@end
