//
//  MyLabel.m
//  团购项目
//
//  Created by 蔡欣东 on 15/9/13.
//  Copyright (c) 2015年 蔡欣东. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    /*
     1.获取上下文对象
     2.设置画线起点
     3.画线，设置终点
     4.渲染到屏幕上
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, rect.size.height/2-4);//起点
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2-4);
    CGContextStrokePath(context);//画线，渲染到屏幕上
}


@end
