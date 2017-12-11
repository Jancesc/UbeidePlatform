//
//  NGGPrizeTableViewCell.m
//  Sport
//
//  Created by Jan on 08/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGPrizeTableViewCell.h"

@interface NGGPrizeTableViewCell () {
    
    __weak IBOutlet UIImageView *_logoImageVIew;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_countLabel;
   
    
}

@end

@implementation NGGPrizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
//    "order_id": "221426852717464383",
//    "goods_name": "20元充值卡",
//    "goods_pic": "http://wx7.bigh5.com/fb/web/uploads/1711/081011231434.png",
//    "status": "3"
    _cellInfo = cellInfo;
}

@end
