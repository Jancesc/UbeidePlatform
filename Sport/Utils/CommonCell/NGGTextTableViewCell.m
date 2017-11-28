//
//  NGGTextTableViewCell.m
//  Sport
//
//  Created by Jan on 24/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGTextTableViewCell.h"
@interface NGGTextTableViewCell() {
    
    __weak IBOutlet UILabel *_namelabel;
    __weak IBOutlet UILabel *_descLabel;
    __weak IBOutlet UILabel *_textlaebl;
}
@end
@implementation NGGTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NGGCommonCellModel *)model {
    
    [super setModel:model];
    
    _namelabel.text = model.title;
    _descLabel.text = model.desc;
    _textlaebl.text = model.value;
    
}
@end
