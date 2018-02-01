//
//  NGGTaskTableViewCell.m
//  sport
//
//  Created by Jan on 01/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTaskTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface NGGTaskTableViewCell () {
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_finishLabel;
    __weak IBOutlet UIButton *_statusButton;
    __weak IBOutlet UILabel *_coinLabel;
    __weak IBOutlet UILabel *_tipsLabel;
    __weak IBOutlet UILabel *_pointLabel;
}

@end

@implementation NGGTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _statusButton.layer.cornerRadius = 0.5 * VIEW_H(_statusButton);
//    _statusButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
//    "id": "1",
//    "title": "登录",
//    "title_pic": "http://wx7.bigh5.com/fb/web/uploads/1710/171511171382.png",
//    "explain": "每日登录获得30金豆",
//    "quantity": "30",
//    "award_type": "1",    奖励类型，1积分 2金豆
//    "status": "0"  状态 0未完成 1可领取 2已领取
    
    _titleLabel.text = [cellInfo stringForKey:@"title"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"title_pic"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _tipsLabel.text = [cellInfo stringForKey:@"explain"];
    
    NSInteger awardType = [cellInfo intForKey:@"award_type"];
    NSString *awardUnit = awardType == 1 ? @"积分" : @"金豆";
    
    NSInteger status = [cellInfo intForKey:@"status"];
    switch (status) {
      
        case 0: {//未完成
         
            _coinLabel.text = [NSString stringWithFormat:@"%@ %@", [cellInfo stringForKey:@"quantity"], awardUnit];
            _finishLabel.textColor = NGGPrimaryColor;
            _finishLabel.text = @"未完成";
            [_statusButton setTitle:@"去完成" forState:UIControlStateNormal];
            [_statusButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGB(0x54, 0x68, 0xe2)] forState:UIControlStateNormal];
            _pointLabel.hidden = YES;
            _statusButton.hidden = NO;
            _coinLabel.hidden = NO;
            break;
        }
        case 1: {//可领取
            
            _coinLabel.text = [NSString stringWithFormat:@"%@ %@", [cellInfo stringForKey:@"quantity"], awardUnit];
            _finishLabel.textColor = NGGThirdColor;
            _finishLabel.text = @"已完成";
            [_statusButton setTitle:@"领取" forState:UIControlStateNormal];
            [_statusButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
            _pointLabel.hidden = YES;
            _statusButton.hidden = NO;
            _coinLabel.hidden = NO;
            break;
        }
        case 2: {//已领取

            _pointLabel.text = [NSString stringWithFormat:@"%@ %@", [cellInfo stringForKey:@"quantity"], awardUnit];
            _finishLabel.textColor = NGGThirdColor;
            _finishLabel.text = @"已完成";
            _pointLabel.hidden = NO;
            _statusButton.hidden = YES;
            _coinLabel.hidden = YES;
            break;
        }
        default:
            break;
    }
}

@end
