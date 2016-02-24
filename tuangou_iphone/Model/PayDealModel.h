//
//  PayDealModel.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/22.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dealModel.h"
@interface PayDealModel : NSObject
@property(nonatomic,strong)NSString* paydealID;
@property(nonatomic,strong)NSString* titlt;
@property(nonatomic,strong)NSString* paydealImgUrl;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)float sumPrice;
@property(nonatomic,assign)int status;
@end
