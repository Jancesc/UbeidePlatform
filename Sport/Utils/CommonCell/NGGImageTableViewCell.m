//
//  NGGImageTableViewCell.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGImageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface NGGImageTableViewCell() {
    
    __weak IBOutlet UILabel *_namelabel;
    __weak IBOutlet UILabel *_descLabel;
    __weak IBOutlet UIImageView *_imageView;
    
}
@end
@implementation NGGImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imageView.layer.cornerRadius = 20;
    _imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NGGCommonCellModel *)model {
    
    [super setModel:model];

    _namelabel.text = model.title;
    _descLabel.text = model.desc;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.value]];
}

@end
