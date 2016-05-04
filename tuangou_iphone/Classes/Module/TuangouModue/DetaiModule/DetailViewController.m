//
//  DetailViewController.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/30.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "DetailViewController.h"
#import "dealGoodsViewController.h"
#import "MyMapNaviViewController.h"
@interface DetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectedBtn;
@property(nonatomic,strong)NSDictionary* dict;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData* data = [FastCoder dataWithRootObject:_model];
    _dict = @{data1:data};
    self.title = @"商品详情";
    [self setupView];
    [self checkIsCollected];
    NSLog(@"businesses_id is %@",_model.businesses_id);
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航按钮
- (IBAction)naviBtnClick:(UIButton *)sender {
    MyMapNaviViewController* mmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyMapNaviViewController"];
    mmvc.latitude = _model.businesses_latitude;
    mmvc.longitude = _model.businesses_longitude;
    mmvc.name  = _model.title;
    [self.navigationController pushViewController:mmvc animated:YES];
}

-(void)setupView{
    _webView.delegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.allowsLinkPreview = NO;
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_model.deal_h5_url]];
    [_webView loadRequest:request];
    _webView.hidden = YES;
    _currentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[_model.current_price floatValue]];
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"加载数据中";
    hud.userInteractionEnabled = NO;
}
#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
    
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('header')[0].style.display = 'none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('cost-box')[0].style.display = 'none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('buy-now')[0].style.display = 'none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('footer')[0].style.display = 'none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('footer-btn-fix')[0].style.display = 'none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('detail-info group-other J_group-other')[0].style.display = 'none';"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _webView.hidden = NO;
    [self checkIsCollected];
}
- (IBAction)collectBtnClick:(UIButton *)sender {
    if (sender.selected == YES) {
        [sender setSelected:NO];
        
        [CollectionData removeObjectFromCollection:_dict];
    
    }else{
        [sender setSelected:YES];
       [CollectionData addObjectToCollection:_dict];

    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        return NO;
    
    }
    else{
        return YES;
    }

}
#pragma mark - 检查是否被收藏
-(void)checkIsCollected{
    NSArray* arr = [CollectionData getCollection];
    if ([arr containsObject:_dict]) {
        [_collectedBtn setSelected:YES];
    }else{
        [_collectedBtn setSelected:NO];
    }
}
- (IBAction)buyBtnClick:(UIButton *)sender {
    dealGoodsViewController* dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dealGoodsViewController"];
    dvc.model = _model;
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
