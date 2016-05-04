//
//  PayDealTableViewCell.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/22.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayDealModel.h"

@protocol PayDealTableViewCellDelegate <NSObject>

-(void)cancleDealBtnClick:(UIButton *)sender;

-(void)payBtnClick:(UIButton *)sender;

@end

@interface PayDealTableViewCell : UITableViewCell
@property(assign,nonatomic)id<PayDealTableViewCellDelegate> delegate;
+(CGFloat)heightOfCell;
-(void)showUIWithModel:(PayDealModel*) model;

@end
