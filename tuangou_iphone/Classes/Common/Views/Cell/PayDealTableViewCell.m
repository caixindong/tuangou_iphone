//
//  PayDealTableViewCell.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/22.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "PayDealTableViewCell.h"

@interface PayDealTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *payTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;

@end

@implementation PayDealTableViewCell

- (void)awakeFromNib {
    //self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    
}
+(CGFloat)heightOfCell{
    return 230;
}
-(void)showUIWithModel:(PayDealModel*) model{
    _payTitleLabel.text = model.titlt;
    _countLabel.text = [NSString stringWithFormat:@"%d",model.count];
    _sumPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.sumPrice];
    [_payImageView sd_setImageWithURL:[NSURL URLWithString:model.paydealImgUrl]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)cancleDealBtnClick:(UIButton *)sender {
    NSLog(@"cancle");
    [self.delegate cancleDealBtnClick:sender];
}
- (IBAction)payBtnClick:(UIButton *)sender {
    [self.delegate payBtnClick:sender];
}

@end
