//
//  XDIndexPath.m
//  XDDropDownMenu
//
//  Created by 蔡欣东 on 16/5/2.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDIndexPath.h"

@implementation XDIndexPath
-(instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row{
    if (self = [super init]) {
        _column = column;
        _leftOrRight = leftOrRight;
        _leftRow = leftRow;
        _row = row;
    }
    return self;
}

@end
