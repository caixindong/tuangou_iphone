//
//  CollectedTableViewCell.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/11.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CollectedTableViewCell : UITableViewCell
+(CGFloat)heightOfCell;
-(void)showUIWithDict:(NSDictionary *)dict;
@end
