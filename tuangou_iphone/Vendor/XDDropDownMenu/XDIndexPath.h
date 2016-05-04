//
//  XDIndexPath.h
//  XDDropDownMenu
//
//  Created by 蔡欣东 on 16/5/2.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDIndexPath : NSObject

/**
 * column 所在的列
 * leftOrRight 位于左tableview还是右tableview，0为左，1为右
 * leftRow 左边所选的行
 * row 所选的行
 **/
@property(nonatomic,assign)NSInteger column;
@property(nonatomic,assign)NSInteger leftOrRight;
@property(nonatomic,assign)NSInteger leftRow;
@property(nonatomic,assign)NSInteger row;
-(instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end
