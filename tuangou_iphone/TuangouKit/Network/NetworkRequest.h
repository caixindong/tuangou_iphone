//
//  NetworkRequest.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/28.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPAPI.h"
@interface NetworkRequest : NSObject
-(instancetype)initWithDelegate:(id<DPRequestDelegate>) delegate;
-(void)requestWithParams:(NSMutableDictionary*) params;
@end
