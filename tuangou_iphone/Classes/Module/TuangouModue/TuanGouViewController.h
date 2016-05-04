//
//  TuanGouViewController.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/28.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuanGouViewController : UIViewController

/**
 * myFlag=1时，为首页点击item生成的界面
**/
@property(nonatomic,assign)int myFlag;
@property(nonatomic,copy)NSString* selectCityName;
@property(nonatomic,copy)NSString* selectCategory;


@end
