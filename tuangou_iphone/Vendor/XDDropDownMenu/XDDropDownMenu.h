//
//  XDDropDownMenu.h
//  XDDropDownMenu
//
//  Created by 蔡欣东 on 16/5/2.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDIndexPath.h"

@class XDDropDownMenu;

#pragma mark - dataSource
@protocol XDDropDownMenuDataSource <NSObject>
@required
/**
 * 每一列的title
 **/
- (NSString *)menu:(XDDropDownMenu *)menu titleForColumn:(NSInteger)column;
/**
 * 每行显示多少列
 **/
-(NSInteger)menu:(XDDropDownMenu*)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
/**
 * 每一个单元格的文本
 **/
- (NSString *)menu:(XDDropDownMenu *)menu titleForRowAtIndexPath:(XDIndexPath *)indexPath;

/**
 * 左边表格显示的比例
 **/
-(CGFloat)proportionOfWidthInLeftColumn:(NSInteger)column;

/**
 * 是否显示二级表格
 **/
-(BOOL)haveRightTableInColumn:(NSInteger)column;

/**
 * 返回一级表格所选的行
 **/
-(NSInteger)currentSelectedRowInLeftTableOfColumn:(NSInteger)column;

@optional
/**
 * 多少列
 **/
- (NSInteger)numberOfColumnsInMenu:(XDDropDownMenu *)menu;
@end

#pragma mark - delegate

@protocol XDDropDownMenuDelegate <NSObject>
- (void)menu:(XDDropDownMenu *)menu didSelectRowAtIndexPath:(XDIndexPath *)indexPath;
@end

#pragma mark - interface
@interface XDDropDownMenu : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id<XDDropDownMenuDataSource> datasource;
@property(nonatomic,assign)id<XDDropDownMenuDelegate> delegate;

@property(nonatomic,strong)UIColor* textColor;
@property(nonatomic,strong)UIColor* seperatorColor;
@property (nonatomic, strong) UIColor *indicatorColor;

-(instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
@end
