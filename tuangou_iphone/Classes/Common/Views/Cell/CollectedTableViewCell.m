//
//  CollectedTableViewCell.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/11.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "CollectedTableViewCell.h"

@interface CollectedTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end

@implementation CollectedTableViewCell

- (void)awakeFromNib {
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}

-(void)showUIWithDict:(NSDictionary *)dict{
    NSData* data = dict[data1];
    dealModel* model = (dealModel*)[FastCoder objectWithData:data];
    _titleLabel.text = model.title;
    _detailLabel.text = model.Description;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.current_price floatValue]];
    [_myImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    
}
+(CGFloat)heightOfCell{
    return 108;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
