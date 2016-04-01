//
//  BaseViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/5.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
