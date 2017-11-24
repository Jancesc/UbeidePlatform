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

@end
