//
//  NetworkRequest.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/28.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest()
@property(nonatomic,strong)DPAPI* api;
@property(nonatomic,assign)id<DPRequestDelegate> delegate;
@end
BOOL haveNet;

@implementation NetworkRequest
-(instancetype)initWithDelegate:(id<DPRequestDelegate>)delegate{
    if (self=[super init]) {
        _api = [[DPAPI alloc]init];
        _delegate = delegate;
    }
    return self;
}
-(void)requestWithParams:(NSMutableDictionary *)params{
    [_api requestWithURL:@"v1/deal/find_deals" params:params delegate:_delegate];
}
@end
