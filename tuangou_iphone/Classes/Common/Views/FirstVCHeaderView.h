//
//  FirstVCHeaderView.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/12/2.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstVCHeaderViewDelegate <NSObject>
-(void)itemClick:(UIButton *)sender;
@end

@interface FirstVCHeaderView : UIView
@property(nonatomic,assign)id<FirstVCHeaderViewDelegate> delegate;
-(instancetype)init;
@end
