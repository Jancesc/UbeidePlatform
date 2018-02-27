//
//  NGGPrizeTableViewCell.m
//  Sport
//
//  Created by Jan on 08/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGPrizeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JYCommonTool.h"

@interface NGGPrizeTableViewCell () {
    
    __weak IBOutlet UIImageView *_logoImageVIew;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UIButton *_statusButton;
}

@end

@implementation NGGPrizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self configueUIComponents];
}

- (void)configueUIComponents {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
//    "order_id": "221426852717464383",
//    "goods_name": "20元充值卡",
//    "goods_pic": "http://wx7.bigh5.com/fb/web/uploads/1711/081011231434.png",
    //    "status": "3"//1待领取 2已领取 3已截止

//    "et": "1512978944",

    _cellInfo = cellInfo;
    [_logoImageVIew sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"goods_pic"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _nameLabel.text = [cellInfo stringForKey:@"goods_name"];
    _timeLabel.text = [NSString stringWithFormat:@"兑奖截止时间:%@", [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"et"] format:@"yyyy-MM-dd HH:mm"]];
    NSInteger status = [cellInfo intForKey:@"status"];
//    1待领取 2已领取 3已截止
    switch (status) {
            
        case 1: {//待领取
            
            [_statusButton setTitle:@"领取" forState:UIControlStateNormal];
            [_statusButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];

            break;
        }
        case 2: {//已领取
            
            [_statusButton setTitle:@"已领取" forState:UIControlStateNormal];
            [_statusButton setBackgroundImage:[UIImage imageWithColor:NGGPrimaryColor] forState:UIControlStateNormal];
            break;
        }
        case 3: {//已截止
            
            [_statusButton setTitle:@"已截止" forState:UIControlStateNormal];
            [_statusButton setBackgroundImage:[UIImage imageWithColor:NGGColorCCC] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

@end
