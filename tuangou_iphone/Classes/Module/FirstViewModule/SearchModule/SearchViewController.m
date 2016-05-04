//
//  SearchViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/31.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar1;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [_searchBar1 resignFirstResponder];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    [_searchBar1 resignFirstResponder];
    NSString* text = _searchBar1.text;
    SearchResultViewController* src  = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    src.searchText = text;
    [self.navigationController pushViewController:src animated:NO];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString* text = searchBar.text;
    SearchResultViewController* src  = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
    src.searchText = text;
    [self.navigationController pushViewController:src animated:NO];
}
@end
