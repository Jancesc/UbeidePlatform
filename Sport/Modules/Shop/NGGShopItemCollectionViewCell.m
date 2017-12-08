//
//  NGGShopItemCollectionViewCell.m
//  Sport
//
//  Created by Jan on 06/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGShopItemCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "JYCommonTool.h"

@interface NGGShopItemCollectionViewCell () {
    
    __weak IBOutlet UIImageView *_logoImageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_priceLabel;
    __weak IBOutlet UILabel *_dateLabel;
    
}
@end

@implementation NGGShopItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10.f;
    self.clipsToBounds = YES;
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    
//    "goods_id": "5",
//    "goods_name": "2014巴西世界杯大力神杯",
//    "goods_pic": "http://wx7.bigh5.com/fb/web/uploads/1710/091829177731.jpg",
//    "need_bean": "580000",
//    "et": "1510396159"

    _cellInfo = cellInfo;
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString: [cellInfo stringForKey:@"goods_pic"]]
                      placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _nameLabel.text = [cellInfo stringForKey:@"goods_name"];
    _priceLabel.text = [cellInfo stringForKey:@"need_bean"];
    _dateLabel.text = [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"et"] format:@"抽奖截止：yyyy-MM-dd"];
}

@end
