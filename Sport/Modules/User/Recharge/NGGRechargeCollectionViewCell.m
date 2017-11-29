//
//  NGGRechargeCollectionViewCell.m
//  Sport
//
//  Created by Jan on 28/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRechargeCollectionViewCell.h"

@interface NGGRechargeCollectionViewCell() {
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_priceLabel;
}

@end

@implementation NGGRechargeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NGGRechargeModel *)model {
    
    self.layer.cornerRadius = 5.f;
    self.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    _model = model;
    _titleLabel.text = model.title;
    _imageView.image = [UIImage imageNamed:model.image];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
}

@end
