//
//  DealTableViewCell.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/10/28.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "DealTableViewCell.h"

@interface DealTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation DealTableViewCell

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}
-(void)showUIWithModel:(dealModel *)model{
    _titleLabel.text = model.title;
    _detailLabel.text = model.Description;
    _currentPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.current_price floatValue]];;
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.list_price];
    _saleNumberLabel.text = [NSString stringWithFormat:@"销量%@",model.purchase_count];;
    [_dealImage sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
}
+(CGFloat)heightOfCell{
    return 120;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
